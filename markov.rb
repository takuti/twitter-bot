# coding: utf-8

require 'igo-ruby'
require 'nkf'
require 'open-uri'
require 'json'

BEGIN_FLG = '[BEGIN]'
END_FLG = '[END]'

class Markov
  def initialize(tweets)
    @tagger = Igo::Tagger.new('./ipadic')

    # 3階のマルコフ連鎖
    @markov_table = Array.new
    markov_index = 0

    # 形態素3つずつから成るテーブルを生成
    tweets.each do |tweet|
      tweet = tweet.to_s # 数字だけのツイートでunpack('U*')がエラーを吐くので全てtoString
      next if NKF.guess(tweet) != NKF::UTF8

      tweet = tweet.gsub(/\.?\s*@[0-9A-Za-z_]+/, '')  # リプライをすべて削除
      tweet = tweet.gsub(/(RT|QT)\s*@?[0-9A-Za-z_]+.*$/, '')  # RT/QT以降行末まで削除
      tweet = tweet.gsub(/http:\/\/\S+/, '')  # URLを削除 スペースが入るまで消える
      tweet = tweet.gsub(/#[0-9A-Za-z_]+/, '')  # ハッシュタグを削除

      wakati_array = Array.new
      wakati_array << BEGIN_FLG
      wakati_array += @tagger.wakati(tweet)
      wakati_array << END_FLG

      # 要素は最低4つあれば[BEGIN]で始まるものと[END]で終わるものの2つが作れる　
      next if wakati_array.size < 4
      i = 0
      loop do
        @markov_table[markov_index] = Array.new
        @markov_table[markov_index] << wakati_array[i]
        @markov_table[markov_index] << wakati_array[i+1]
        @markov_table[markov_index] << wakati_array[i+2]
        markov_index += 1
        break if wakati_array[i+2] == END_FLG
        i += 1
      end
    end
  end

  def generate_tweet
    while true
      # 先頭（[BEGIN]から始まるもの）を選択
      selected_array = Array.new
      @markov_table.each do |markov_array|
        if markov_array[0] == BEGIN_FLG
          selected_array << markov_array
        end
      end
      selected = selected_array.sample
      markov_tweet = selected[1] + selected[2]
      # 以後、[END]で終わるものを拾うまで連鎖を続ける
      loop do
        selected_array = Array.new
        @markov_table.each do |markov_array|
          if markov_array[0] == selected[2]
            selected_array << markov_array
          end
        end
        break if selected_array.size == 0 # 連鎖できなければ諦める
        selected = selected_array.sample
        if selected[2] == END_FLG
          markov_tweet += selected[1]
          break
        else
          markov_tweet += selected[1] + selected[2]
        end
      end
      # If generated tweet size is greater than 100, tweet random Kaomoji
      if markov_tweet.size > 100
        begin
          markov_tweet = get_kaomoji
          break
        rescue
          next
        end
      else
        break
      end
    end
    markov_tweet
  end

  def get_kaomoji
    open('http://kaomoji.n-at.me/random.json') do |f|
      JSON.load(f)['record']['text']
    end
  end
end
