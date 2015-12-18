# coding: utf-8

require 'kusari'
require 'open-uri'
require 'json'

require_relative 'tweet'

class TweetGenerator
  def initialize
    @generator = Kusari::Generator.new(3, File.expand_path('../../ipadic', __FILE__))
    if not @generator.load(File.expand_path('../../tweet.markov', __FILE__))
      # read tweets from official tweet history
      tweets = Array.new
      CSV.foreach(File.expand_path('../../data/tweets/tweets.csv', __FILE__), :headers => true) do |row|
        tweet = Tweet.new(row['text'])
        next if !tweet.text
        tweet.normalize
        @generator.add_string(tweet.text)
      end
      @generator.save(File.expand_path('../../tweet.markov', __FILE__))
    end
  end

  def generate
    t = @generator.generate(140)
    if t.length > 100
      begin
        t = get_kaomoji
      end
    end
    t
  end

  def get_kaomoji
    open('http://kaomoji.n-at.me/random.json') do |f|
      JSON.load(f)['record']['text']
    end
  end
end
