Markov Chain-based Japanese Twitter Bot
===

[![Build Status](https://travis-ci.org/takuti/twitter-bot.svg)](https://travis-ci.org/takuti/twitter-bot)

***Since this project is strongly optimized for Japanese, other languages are not supported :sushi:***

## Description

- Generate a tweet based on so-called **Markov Chain** from particular user's tweet history
- Sample: [@yootakuti](https://twitter.com/yootakuti)
- My Japanese article: [マルコフ連鎖でTwitter Botをつくりました | takuti.me](http://takuti.me/note/twitter-bot/)

## Usage

1. Download tweet history from your Twitter setting page
	- The folder must be placed under **data/**.
	- The program will use *text* column of **data/tweets/tweets.csv**.
2. Install [kusari](https://github.com/takuti/kusari) (Japanese Markov chain library)
	- You must create dictionary as follows: http://igo.osdn.jp/index.html#usage.
	- If the dictionary has been successfully created, now we have **ipadic/** directory.
3. Generate/Post tweet
	- Just generate: `ruby src/main.rb`
	- Post: write API keys in **main.rb**, and `ruby src/main.rb production`

If the length of generated tweet is greater than 100, this bot will post Kaomoji from [kaomoji.html](https://github.com/tatat/kaomoji.html) API because long tweets do not make sense.

## Dependencies

See `Gemfile`

## TODO

- [ ] Improve performance (e.g. store tweets on DB)
- [ ] Realize more humanlike tweet
- [ ] Implement reply feature
- [ ] Incorporate streaming API-based tweet generating logic

## License

MIT

## Author

[takuti](http://github.com/takuti)