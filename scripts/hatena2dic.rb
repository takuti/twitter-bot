# coding: utf-8

require 'moji'
require 'igo-ruby'
require 'nkf'

tagger = Igo::Tagger.new('../ipadic')

source_file = File.open("keywordlist_furigana.csv", "r:euc-jp")
dictionary_file = File.open("hatena.csv", "w:euc-jp")
cnt = 0

while line = source_file.gets do
	# data = [<furigana>, <word>]
	data = NKF.nkf('-E -w',line).gsub(/\n/,'').split("\t")

	word = data[1]
	next if /^[0-9]{1,4}-[0-9]{2}-[0-9]{2}$/ =~ word # 2009-09-04 のような年月は飛ばす
	next if /^[0-9]{1,4}年$/ =~ word # 1945年　のような年は飛ばす
	next if word.include?(",") # 単語そのものにカンマが含まれるものは飛ばす（応急処置）
	next if tagger.wakati(word).size == 1 # すでに1単語として認識されるものは飛ばす\

	furigana = Moji.hira_to_kata(data[0])
	cost = [-32768, (6000 - 200 *(word.length**1.3))].max.to_i

	# 文字コードがCP51932になってしまうものは飛ばす（応急処置）
	dic_row_euc = NKF.nkf('-W -e',"#{word},0,0,#{cost},名詞,一般,*,*,*,*,#{word},#{furigana},#{furigana}")
	if NKF.guess(dic_row_euc) == Encoding::CP51932
		puts "Skip word: #{word}"
	else
		# 元々のMeCab辞書のエンコーディングであるEUCに合わせる
		dictionary_file.puts dic_row_euc
		cnt += 1
	end
end

puts "#{cnt}件の単語を登録しました"

source_file.close
dictionary_file.close
