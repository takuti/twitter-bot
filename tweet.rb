# coding: utf-8

require 'twitter'
require_relative 'markov'

Twitter.configure do |config|
	config.consumer_key = YOUR_CONSUMER_KEY
	config.consumer_secret = YOUR_CONSUMER_SECRET
	config.oauth_token = YOUR_OAUTH_TOKEN
	config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end

markov = Markov.new

# Twitter.update(markov_tweet)
puts "[tweet] #{markov.generate_tweet}"
