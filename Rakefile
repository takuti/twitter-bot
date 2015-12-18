task default: :test
task :setup => ["ipadic:compile", "ipadic:clean"]

namespace :ipadic do
  task :compile do
    if not File.exist?("./ipadic")
      system "wget 'http://osdn.jp/frs/redir.php?m=jaist&f=%2Figo%2F52344%2Figo-0.4.3.jar' -O igo.jar"
      system "wget 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM' -O mecab-ipadic.tar.gz"
      system "tar zxfv mecab-ipadic.tar.gz"
      system "java -cp igo.jar net.reduls.igo.bin.BuildDic ipadic mecab-ipadic-2.7.0-20070801 EUC-JP"
    end
  end

  task :clean do
    system "rm -rf igo.jar mecab-ipadic-2.7.0-20070801 mecab-ipadic.tar.gz"
  end
end

task :test do
  # save markov table on local as "tweet.markov"
  system "ruby lib/post_tweet.rb"

  # load "tweet.markov"; at the second time, generating tweet will be much faster
  system "ruby lib/post_tweet.rb"
end
