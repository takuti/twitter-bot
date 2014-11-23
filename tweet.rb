# coding: utf-8

require 'twitter'
require 'csv'
require_relative 'markov'

tweets_table = Array.new
CSV.foreach('data/tweets/tweets.csv', :headers => true) do |row|
  tweet = normalize_tweet(row['text'])
  next if !tweet
  tweets_table << tweet
end

markov_table = create_markov_table(tweets_table)

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
