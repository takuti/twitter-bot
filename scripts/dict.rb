# coding: utf-8

require 'moji'
require 'igo-ruby'
require 'csv'

module CustomDictionary

  class Writer
    attr_accessor :count

    def initialize(filename)
      # 元々のMeCab辞書のエンコーディングであるEUCに合わせる
      @dictionary_file = CSV.open(filename, 'w', encoding: 'utf-8:euc-jp')
      @count = 0
    end

    def write(word, furigana='*')
      @dictionary_file << [word, 0, 0, cost(word), '名詞', '一般', '*', '*', '*', '*', word, furigana, furigana]
      @count += 1
    end

    def close
      @dictionary_file.close
    end

    private

    def cost(word)
      [-32768, 6000 - 200  * (word.length**1.3)].max.to_i
    end
  end

  class << self
    def hatena(tagger, writer)
      File.open('keywordlist_furigana.csv', encoding: 'euc-jp:utf-8', undef: :replace) do |f|
        CSV.new(f, :col_sep => "\t").each do |row|
          word = row[1]

          next if /^[0-9]{1,4}-[0-9]{2}-[0-9]{2}$/ =~ word # 2009-09-04 のような年月は飛ばす
          next if /^[0-9]{1,4}年$/ =~ word # 1945年　のような年は飛ばす
          next if word.include?(',') # 単語そのものにカンマが含まれるものは飛ばす（応急処置）
          next if tagger.wakati(word).size == 1 # すでに1単語として認識されるものは飛ばす

          furigana = row[0] ? Moji.hira_to_kata(row[0]) : String.new
          writer.write(word, furigana)
        end
      end
    end

    def wikipedia(tagger, writer)
      File.open('jawiki-latest-all-titles-in-ns0', encoding: 'euc-jp:utf-8', undef: :replace) do |f|
        CSV.new(f, :col_sep => "\t").each do |row|
          word = row[0]

          next if /^[0-9]{2}月[0-9]{2}日$/ =~ word # 09月04日 のような月日は飛ばす
          next if /^[0-9\*\-]{1,4}年.*$/ =~ word # 年から始まるものに使えそうなものはほぼ無い
          next if word.include?('_') # 単語そのものにアンダーバーが含まれるものはスペースの入ったタイトルで複雑なので飛ばす（応急処置）
          next if word.include?(',') # 単語そのものにカンマが含まれるものは飛ばす（応急処置）
          next if tagger.wakati(word).size == 1 # すでに1単語として認識されるものは飛ば

          writer.write(word)
        end
      end
    end
  end

end


if !['hatena', 'wikipedia'].include?(ARGV.first)
  abort('`hatena` or `wikipedia` must be specified')
end

tagger = Igo::Tagger.new('../ipadic')
writer = CustomDictionary::Writer.new("#{ARGV.first}.csv")

case ARGV.first
when 'hatena'
  CustomDictionary::hatena(tagger, writer)
when 'wikipedia'
  CustomDictionary::wikipedia(tagger, writer)
end

writer.close

puts "Wrote #{writer.count} words"
