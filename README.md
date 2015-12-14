Markov Chain-based Japanese Twitter Bot
===

[![Build Status](https://travis-ci.org/takuti/twitter-bot.svg)](https://travis-ci.org/takuti/twitter-bot)

***Since this project is strongly optimized for Japanese, other languages are not supported :sushi:***

## Description

- Generate a tweet based on so-called **Markov Chain** from particular user's tweet history
- Sample: [@yootakuti](https://twitter.com/yootakuti)
- My Japanese article: [マルコフ連鎖でTwitter Botをつくりました | takuti.me](http://takuti.me/note/twitter-bot/)

## Installation

After cloning this repository,

	$ gem install bundle
	$ bundle install
	$ rake setup

Note that the Markov chain logic is implemented by ***[kusari](https://github.com/takuti/kusari)***, a gem for Japanese Markov chain. The above `rake setup` command will automatically accomplish to create the required dictionary **ipadic/** by following the installation written in [HERE](http://igo.osdn.jp/index.html#usage).

## Usage

Before enjoying this bot, you must download your tweet history from [the Twitter setting page](https://twitter.com/settings/account). The downloaded folder must be placed under **data/**, and the bot will use *text* column of **data/tweets/tweets.csv**.

### Just generate a random tweet

	$ ruby src/main.rb
	
### Post on Twitter

After replacing the mock Twitter API keys with your actual ones in **src/main.rb**,

	$ ruby src/main.rb production
	
### Hourly post by cron

Set your crontab as:

	$ echo "01 * * * * /usr/local/rvm/wrappers/ruby-2.2.3/ruby /path/to/twitter-bot/src/main.rb production" > cron.txt
	$ crontab cron.txt

For more detail of RVM+cron setting: [RVM: Ruby Version Manager - Using Cron with RVM](https://rvm.io/deployment/cron)

## TODO

- [x] Improve performance (e.g. store tweets on DB)
- [ ] Realize more humanlike tweet
- [ ] Implement reply feature
- [ ] Incorporate streaming API-based tweet generating logic

## License

MIT

## Author

[takuti](http://github.com/takuti)