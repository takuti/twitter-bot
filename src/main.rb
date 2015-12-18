# coding: utf-8

require 'twitter'
require 'kusari'
require 'csv'

require_relative 'tweet_generator'

generator = TweetGenerator.new

# generate and tweet on twitter: `$ ruby main.rb production`
# just generate tweet: `$ ruby main.rb`
if ARGV[0] == 'production'
  rest = Twitter::REST::Client.new do |config|
    config.consumer_key = YOUR_CONSUMER_KEY
    config.consumer_secret = YOUR_CONSUMER_SECRET
    config.access_token = YOUR_ACCESS_TOKEN
    config.access_token_secret = YOUR_ACCESS_TOKEN_SECRET
  end
  rest.update(generator.generate)
else
  puts "[tweet] #{generator.generate}"
end
