# coding: utf-8

require 'igo-ruby'
require 'csv'
require 'nkf'

BEGIN_FLG = '[BEGIN]'
END_FLG = '[END]'

class Markov
	def initialize
		@tagger = Igo::Tagger.new('./ipadic')
		@tweets_table = CSV.table('tweets/tweets.csv')

		# 3階のマルコフ連鎖
		@markov_table = Array.new
		markov_index = 0

		# 形態素3つずつから成るテーブルを生成
		@tweets_table[:text].each do |tweet|
			tweet = tweet.to_s # 数字だけのツイートでunpack('U*')がエラーを吐くので全てtoString
			next if NKF.guess(tweet) != NKF::UTF8

			tweet = tweet.gsub(/^\.?(\s*@[0-9A-Za-z_]+)+/, '')	# 文頭のIDを削除 .をつけていても削除 複数人指定も削除
			tweet = tweet.gsub(/(RT|QT)\s*@?[0-9A-Za-z_]+.*$/, '')	# RT/QT以降行末まで削除
			tweet = tweet.gsub(/http:\/\/\S+/, '')	# URLを削除 スペースが入るまで消える

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
		for times in 1..10
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
			break if markov_tweet.size <= 140 # 140文字以内の文章が生成できれば終了　最大10回までやり直す
		end
		markov_tweet
	end
end
