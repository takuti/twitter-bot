This is twitter bot program by Markov Chain.

[Twitter Bot Development by Markov Chain - blog.takuti.me](http://blog.takuti.me/twitter-bot/) (Japanese)

## Tweet Flow
1. Construct Markov table from my tweet history that is downloaded from twitter official. (Using only CSV file in the tweet history.
	- Using [igo-ruby](https://github.com/kyow/igo-ruby) to do morphological analysis.
2. Generate tweet by Markov Chain.
3. Tweet using [Twitter Ruby Gem](https://github.com/sferik/twitter).

## Reply Daemon
- reply.rb is using Streaming of Twitter Ruby Gem. It's experimental function.
- Run daemon `ruby reply.rb`
- Stop daemon `cat reply_daemon.pid | xargs kill`
	- reply_daemon.pid is created automatically when you run daemon.
- Reference: [http://nuke.hateblo.jp/entry/2013/07/04/090917](http://nuke.hateblo.jp/entry/2013/07/04/090917)

### Sample
- [@yootakuti](https://twitter.com/yootakuti)
- Running `ruby tweet.rb` every 30 minutes.
- Running reply daemon. If you send mention, this guy reply to you.

## TODO
- Get newer tweet history automatically.
- Improve performance. (taking a minute for 50,000 tweets currently)
- Do humanlike tweet.