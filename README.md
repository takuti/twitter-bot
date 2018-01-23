Markov-Chain-Based Japanese Twitter Bot
===

[![Build Status](https://travis-ci.org/takuti/twitter-bot.svg)](https://travis-ci.org/takuti/twitter-bot)

***Since this project is strongly optimized for Japanese, other languages are not supported :sushi:***

## Description

- Generate a tweet based on so-called **Markov Chain** from particular user's tweet history
- Sample: [@yootakuti](https://twitter.com/yootakuti)
- My Japanese article: [マルコフ連鎖でTwitter Botをつくりました | takuti.me](http://takuti.me/note/twitter-bot/)

## Installation

If you want to host this bot directly on your local or server machine, you first need to install Ruby gems:

	$ gem install bundle
	$ bundle install

Note that this application specially depends on [***kusari***](https://github.com/takuti/kusari), a gem for Japanese Markov chain.

Next, you should generate a directory **ipadic/**, the IPA dictionary for Japanese tokenization, as described in the [Igo documentation](http://igo.osdn.jp/index.html#usage).

Additionally, in order to connect to a Twitter account, the following environment variables need to be appropriately set:

```sh
export SCREEN_NAME=yootakuti

export CONSUMER_KEY=foo
export CONSUMER_SECRET=bar
export OAUTH_TOKEN=hoge
export OAUTH_TOKEN_SECRET=piyo
```

FYI: we can use [direnv](https://github.com/direnv/direnv) to flexibly configure project-specific environment variables:

	$ brew install direnv
	$ touch .envrc # and write the above `export` statements
	$ direnv allow

## Usage

Before enjoying this bot, you must download your tweet history from [the Twitter setting page](https://twitter.com/settings/account). The downloaded folder must be placed under **/path/to/twitter-bot/data/**, and the bot will use *text* column of **data/tweets/tweets.csv**. Note that this repository contains [sample tweets.csv file](data/tweets/tweets.csv).

### Post on Twitter

After setting the environment variables, we can generate and post a markov tweet as:

	$ ruby lib/post_tweet.rb

If you just want to check if a markov tweet is generated correctly, `dry-run` option is available.

	$ ruby lib/post_tweet.rb dry-run

#### Hourly post by cron

Set your crontab as:

	$ echo "01 * * * * /usr/local/rvm/wrappers/ruby-2.2.3/ruby /path/to/twitter-bot/lib/post_tweet.rb" > cron.txt
	$ crontab cron.txt

For more detail of RVM+cron setting: [RVM: Ruby Version Manager - Using Cron with RVM](https://rvm.io/deployment/cron)

#### Build API server

This repository implements a tiny Sinatra-based API server.

Run:

```sh
$ bundle exec foreman start # PORT=5000 by default
```

Eventually, http://localhost:5000/ and http://localhost:5000/tweet respectively execute `lib/post_tweet.rb dry-run` and `lib/post_tweet.rb`.

In case that you publicly build this API server, scheduling a request to `/tweet` would be an alternative choice to periodically post Markov-chain-based tweet.

### Reply daemon

`reply_daemon` tracks tweets which contain `SCREEN_NAME` of your bot and replies to all of them:

	$ ruby lib/reply_daemon.rb start

Stop the process:

	$ ruby lib/reply_daemon.rb stop

## Docker

You can easily setup this application as a Docker image:

```sh
$ docker build -t takuti/twitter-bot
```

Once the image has been created, running the scripts in container is straightforward:

```sh
$ docker run -it takuti/twitter-bot /bin/sh -c "ruby lib/post_tweet.rb"
$ docker run -it takuti/twitter-bot /bin/sh -c "ruby lib/post_tweet.rb dry-run"
```

By default, container automatically launches the API sever on port 5000 via `bundle exec foreman start`, so you can get access to http://localhost:5000/ once a container started running:

```sh
$ docker run -it -d -p 5000:5000 takuti/twitter-bot
```

Notice that, as long as the required environmental variables are properly set in container, http://localhost:5000/tweet also works as we expected.

### Deploy on Heroku

Our Docker image enables us to make the API server public on Heroku:

```sh
$ heroku create takuti-twitter-bot
$ heroku container:push web
```

See https://takuti-twitter-bot.herokuapp.com/, for example.

While https://takuti-twitter-bot.herokuapp.com/tweet currently returns an error, you can make it available by [configuration of variables](https://devcenter.heroku.com/articles/config-vars#setting-up-config-vars-for-a-deployed-application).

### Deploy on Dokku

[Dokku](https://github.com/dokku/dokku) is a Docker-powered OSS PaaS which enables you to build mini-Heroku-like platform on your own server. Similarly to the deployment on Heroku, once you have set up a server with Dokku, the API server can be easily deployed as a Docker image.

Server:

```sh
$ dokku apps:create twitter-bot
$ dokku config:set twitter-bot DOKKU_DOCKERFILE_START_CMD="bundle exec foreman start"
```

Note that setting a way to start running a container to `DOKKU_DOCKERFILE_START_CMD` is important, because Dokku directly [executes a task defined as the `web` process in `Procfile`](http://dokku.viewdocs.io/dokku/deployment/methods/dockerfiles/#procfiles-and-multiple-processes) by default. Consequently, your container launches differently from what `CMD` defines in `Dockerfile`.

Local:

```sh
$ cd /path/to/takuti/twitter-bot
$ git remote add dokku dokku@dokku.example.com:twitter-bot
$ git push dokku master
```

Eventually, an "Application deployed" message shows up on your local screen with corresponding URL, and you can get access to the API server.