task :test do
  # save markov table on local as "tweet.markov"
  system "ruby lib/post_tweet.rb dry-run"

  # load "tweet.markov"; at the second time, generating tweet will be much faster
  system "ruby lib/post_tweet.rb dry-run"
end
