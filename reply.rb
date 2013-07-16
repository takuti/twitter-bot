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

latest_mention_id = File.open("latest_mention_id.txt", "r").read().to_i

reply_targets = Array.new

Twitter.mentions.each do |status|
	if status.id > latest_mention_id
		reply_targets << status.id
		reply = '@' + status.user.screen_name + ' ' + markov.generate_tweet
		Twitter.update(reply, { "in_reply_to_status_id" => status.id })
		puts '[reply] ' + reply
	end
end

File.open("latest_mention_id.txt", "w").write(reply_targets.max) if reply_targets.size > 0