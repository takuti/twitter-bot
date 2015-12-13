# coding: utf-8

require 'twitter'
require 'kusari'
require 'csv'

require_relative 'tweet'

def get_kaomoji
  require 'open-uri'
  require 'json'

  open('http://kaomoji.n-at.me/random.json') do |f|
    JSON.load(f)['record']['text']
  end
end

generator = Kusari::Generator.new

if not generator.load('./tweet.markov')
  # read tweets from official tweet history
  tweets = Array.new
  CSV.foreach('data/tweets/tweets.csv', :headers => true) do |row|
    tweet = Tweet.new(row['text'])
    next if !tweet.text
    tweet.normalize
    generator.add_string(tweet.text)
  end
  generator.save('./tweet.markov')
end

tweet = generator.generate(140)

if tweet.length > 100
  begin
    tweet = get_kaomoji
  end
end

# generate and tweet on twitter: `$ ruby main.rb production`
# just generate tweet: `$ ruby main.rb`
if ARGV[0] == 'production'
  rest = Twitter::REST::Client.new do |config|
    config.consumer_key = YOUR_CONSUMER_KEY
    config.consumer_secret = YOUR_CONSUMER_SECRET
    config.oauth_token = YOUR_OAUTH_TOKEN
    config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
  end
  rest.update(tweet)
else
  puts "[tweet] #{tweet}"
end
