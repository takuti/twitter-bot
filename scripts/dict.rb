# coding: utf-8

require 'moji'
require 'igo-ruby'
require 'nkf'

def cost(word)
  [-32768, 6000 - 200  * (word.length**1.3)].max.to_i
end

tagger = Igo::Tagger.new('../ipadic')
cnt = 0

case ARGV.first
when 'hatena'
  source_file = File.open("keywordlist_furigana.csv", "r:euc-jp")
  dictionary_file = File.open("hatena.csv", "w:euc-jp")
  while line = source_file.gets do
    # data = [<furigana>, <word>]
    data = NKF.nkf('-E -w',line).gsub(/\n/,'').split("\t")

    word = data[1]
    next if /^[0-9]{1,4}-[0-9]{2}-[0-9]{2}$/ =~ word # 2009-09-04 のような年月は飛ばす
    next if /^[0-9]{1,4}年$/ =~ word # 1945年　のような年は飛ばす
    next if word.include?(",") # 単語そのものにカンマが含まれるものは飛ばす（応急処置）
    next if tagger.wakati(word).size == 1 # すでに1単語として認識されるものは飛ばす\

    furigana = Moji.hira_to_kata(data[0])

    # 文字コードがCP51932になってしまうものは飛ばす（応急処置）
    dic_row_euc = NKF.nkf('-W -e',"#{word},0,0,#{cost(word)},名詞,一般,*,*,*,*,#{word},#{furigana},#{furigana}")
    if NKF.guess(dic_row_euc) == Encoding::CP51932
      puts "Skip word: #{word}"
    else
      # 元々のMeCab辞書のエンコーディングであるEUCに合わせる
      dictionary_file.puts dic_row_euc
      cnt += 1
    end
  end
  dictionary_file.close
  source_file.close
when 'wikipedia'
  source_file = File.open("jawiki-latest-all-titles", "r")
  dictionary_file = File.open("wikipedia.csv", "w:euc-jp")
  while word = source_file.gets do
    next if /^[0-9]{2}月[0-9]{2}日$/ =~ word # 09月04日 のような月日は飛ばす
    next if /^[0-9\*\-]{1,4}年.*$/ =~ word # 年から始まるものに使えそうなものはほぼ無い
    next if word.include?("_") # 単語そのものにアンダーバーが含まれるものはスペースの入ったタイトルで複雑なので飛ばす（応急処置）
    next if word.include?(",") # 単語そのものにカンマが含まれるものは飛ばす（応急処置）
    next if tagger.wakati(word).size == 1 # すでに1単語として認識されるものは飛ばす\

    # 文字コードがCP51932になってしまうものは飛ばす（応急処置）
    dic_row_euc = NKF.nkf('-W -e',"#{word},0,0,#{cost(word)},名詞,一般,*,*,*,*,#{word},,")
    if NKF.guess(dic_row_euc) == Encoding::CP51932
      puts "Skip word: #{word}"
    else
      # 元々のMeCab辞書のエンコーディングであるEUCに合わせる
      dictionary_file.puts dic_row_euc
      cnt += 1
    end

  end
  dictionary_file.close
  source_file.close
end

puts "#{cnt}件の単語を登録しました"
