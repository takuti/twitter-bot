# coding: utf-8

require 'twitter'
require 'kusari'

require_relative 'twitter_bot/tweet_generator'

generator = TwitterBot::TweetGenerator.new

case ARGV.first
when 'dry-run'
  puts "[tweet] #{generator.generate}"
else
  rest = Twitter::REST::Client.new do |config|
    config.consumer_key = CONSUMER_KEY
    config.consumer_secret = CONSUMER_SECRET
    config.access_token = OAUTH_TOKEN
    config.access_token_secret = OAUTH_TOKEN_SECRET
  end
  rest.update(generator.generate)
end
