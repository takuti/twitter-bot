Markov Chain-based Japanese Twitter Bot
===

[![Build Status](https://travis-ci.org/takuti/twitter-bot.svg)](https://travis-ci.org/takuti/twitter-bot)

***Since this project is strongly optimized for Japanese, other languages are not supported :sushi:***

## Description

- Generate a tweet based on so-called **Markov Chain** from particular user's tweet history
- Sample: [@yootakuti](https://twitter.com/yootakuti)
- My Japanese article: [マルコフ連鎖でTwitter Botをつくりました - blog.takuti.me](http://blog.takuti.me/twitter-bot/)

## Usage

1. Download tweet history from your Twitter setting page
	- The folder must be placed under **data/**
	- The program will use *text* column of **data/tweets/tweets.csv**
2. Install [igo-ruby](https://github.com/kyow/igo-ruby) (Japanese morphological analysis library)
	- Dictionary's directory: **ipadic/**
3. Generate/Post tweet
	- Just generate: `ruby main.rb`
	- Post: write API keys in **main.rb**, and `ruby main.rb production`

If the length of generated tweet is greater than 100, this bot will post Kaomoji from [kaomoji.html](https://github.com/tatat/kaomoji.html) API because long tweets do not make sense.

## TODO

- [ ] Improve performance (e.g. store tweets on DB)
- [ ] Realize more humanlike tweet
- [ ] Implement reply feature
	- **reply.rb** can answer to replies found on your timeline
	- Daemon
		- Run: `ruby reply.rb`
		- Stop: `cat reply_daemon.pid | xargs kill`
		- A file **reply_daemon.pid** will be generated automatically
		- Reference: [http://nuke.hateblo.jp/entry/2013/07/04/090917](http://nuke.hateblo.jp/entry/2013/07/04/090917)

## License

MIT

## Author

[takuti](http://github.com/takuti)