require 'sinatra'

require 'twitter'
require_relative 'lib/twitter_bot/tweet_generator'

get '/' do
  begin
    TwitterBot::TweetGenerator.new.generate
  rescue
    halt 500, 'Failed to generate a tweet. Make sure a directory /ipadic exists.'
  end
end

get '/tweet' do
  begin
    tweet = TwitterBot::TweetGenerator.new.generate
  rescue
    halt 500, 'Failed to generate a tweet. Make sure a directory /ipadic exists.'
  end

  rest = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
    config.access_token = ENV['OAUTH_TOKEN']
    config.access_token_secret = ENV['OAUTH_TOKEN_SECRET']
  end

  begin
    rest.update(tweet)
  rescue
    halt 500, "Failed to post a generated tweet: #{tweet}"
  end
  "Tweeted: #{tweet}"
end
