# coding: utf-8

require 'kusari'
require 'open-uri'
require 'json'
require 'csv'

require_relative 'tweet'

module TwitterBot
  class TweetGenerator
    def initialize
      root = File.expand_path('../../../', __FILE__)
      @generator = Kusari::Generator.new(3, "#{root}/ipadic")
      if not @generator.load("#{root}/tweet.markov")
        # read tweets from official tweet history
        tweets = Array.new
        CSV.foreach("#{root}/data/tweets/tweets.csv", :headers => true) do |row|
          tweet = Tweet.new(row['text'])
          next if !tweet.text
          tweet.normalize!
          @generator.add_string(tweet.text)
        end
        @generator.save("#{root}/tweet.markov")
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

    private

    def get_kaomoji
      open('http://kaomoji.n-at.me/random.json') do |f|
        JSON.load(f)['record']['text']
      end
    end
  end
end
