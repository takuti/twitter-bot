# coding: utf-8

require 'tweetstream'
require 'twitter'
require_relative 'twitter_bot/tweet_generator'

# Since streaming feature of Twitter gem is still experimental,
# TweetStream gem will be used to track tweets on stream
TweetStream.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.oauth_token = ENV['OAUTH_TOKEN']
  config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
  config.auth_method = :oauth
end

rest = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.access_token = ENV['OAUTH_TOKEN']
  config.access_token_secret = ENV['OAUTH_TOKEN_SECRET']
end

generator = TwitterBot::TweetGenerator.new

# non-daemonized tracking:
# TweetStream::Client.new.track(ENV['SCREEN_NAME']) do |status|

TweetStream::Daemon.new('tracker').track(ENV['SCREEN_NAME']) do |status|
  t = "@#{status.user.screen_name} #{generator.generate}"
  rest.update(t, in_reply_to_status_id: status.id)
end
