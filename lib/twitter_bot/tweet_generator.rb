# coding: utf-8

require 'kusari'
require 'open-uri'
require 'json'
require 'csv'

require_relative 'tweet'

module TwitterBot
  class TweetGenerator
    def initialize
      @root = File.expand_path('../../../', __FILE__)
      @generator = Kusari::Generator.new(3, "#{@root}/ipadic")
      create_markov if @generator.load("#{@root}/tweet.markov") == false
    end

    def generate
      t = @generator.generate(140)
      t.length > 70 ? get_kaomoji : t # avoid very long random sentence
    end

    private

    def create_markov
      CSV.foreach("#{@root}/data/tweets/tweets.csv", :headers => true) do |row|
        t = Tweet.new(row['text'])
        next if t.text.nil?
        t.normalize!
        @generator.add_string(t.text)
      end
      @generator.save("#{@root}/tweet.markov")
    end

    def get_kaomoji
      begin
        open('http://kaomoji.n-at.me/random.json') { |f| JSON.load(f)['record']['text'] }
      rescue
        @generator.generate(70) # alternative short tweet
      end
    end
  end
end
