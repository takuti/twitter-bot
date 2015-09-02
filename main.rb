# coding: utf-8

require 'twitter'
require 'csv'
require_relative 'markov'

# read tweets from official tweet history
tweets = Array.new
CSV.foreach('data/tweets/tweets.csv', :headers => true) do |row|
  tweet = Tweet.new(row['text'])
  next if !tweet.text
  tweet.normalize
  tweets << tweet
end

# create markov table which has all 3-grams based on the tweets table
markov = Markov.new(tweets)

# generate and tweet on twitter: `$ ruby main.rb production`
# just generate tweet: `$ ruby main.rb`
if ARGV[0] == 'production'
  rest = Twitter::REST::Client.new do |config|
    config.consumer_key = YOUR_CONSUMER_KEY
    config.consumer_secret = YOUR_CONSUMER_SECRET
    config.oauth_token = YOUR_OAUTH_TOKEN
    config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
  end
  rest.update(markov.generate)
else
  puts "[tweet] #{markov.generate}"
end
