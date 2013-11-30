This is twitter bot program using Markov Chain.

[twitter bot development using Markov Chain](http://blog.takuti.me/twitter-bot/) (Japanese)

## Usage
1. Download your tweet history from twitter setting page. **tweet.rb** uses CSV file of your tweet history.
2. Install [igo-ruby](https://github.com/kyow/igo-ruby).
3. Install [Twitter Ruby Gem](https://github.com/sferik/twitter).
4. Run `ruby tweet.rb`

### Sample
- [@yootakuti](https://twitter.com/yootakuti)
- Running `ruby tweet.rb` every 30 minutes.

## Reply (this is incomplete function)
- First time, you should make one text file that is called **latest\_mention\_id.txt**. It memorizes latest reply tweet ID at previous step.
- If you have no mentions, please input 0 to **latest\_mention\_id.txt**.
- After second time, **latest_mention_id.txt** is updated automatically when run `ruby reply.rb`.

Example of **latest\_mention\_id.txt** content is -> `356989334773170176`

## TODO
- Get newer tweet history automatically.
- Implement reply function completely.
- Improve performance. (taking a minute for 50,000 tweets currently)
