# coding: utf-8

require 'twitter'
require 'csv'
require_relative 'markov'

# read tweets from official tweet history
tweets_table = Array.new
CSV.foreach('data/tweets/tweets.csv', :headers => true) do |row|
  tweet = normalize_tweet(row['text'])
  next if !tweet
  tweets_table << tweet
end

# create markov table which has all 3-grams based on the tweets table
markov_table = create_markov_table(tweets_table)

# generate and tweet on twitter: `$ ruby main.rb production`
# just generate tweet: `$ ruby main.rb`
if ARGV[0] == 'production'
  rest = Twitter::REST::Client.new do |config|
    config.consumer_key = YOUR_CONSUMER_KEY
    config.consumer_secret = YOUR_CONSUMER_SECRET
    config.oauth_token = YOUR_OAUTH_TOKEN
    config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
  end
  rest.update(generate_tweet(markov_table))
else
  puts "[tweet] #{generate_tweet(markov_table)}"
end
