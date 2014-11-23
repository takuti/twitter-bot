# coding: utf-8

require 'twitter'
require 'csv'
require_relative 'markov'

rest = Twitter::REST::Client.new do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end

tweets_table = CSV.table('data/tweets/tweets.csv')
markov = Markov.new(tweets_table[:text])

# rest.update(markov.generate_tweet)
puts "[tweet] #{markov.generate_tweet}"
