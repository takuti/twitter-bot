# coding: utf-8

require 'igo-ruby'
require 'nkf'

BEGIN_FLG = '[BEGIN]'
END_FLG = '[END]'

class Tweet
  attr_accessor :text

  def initialize(text)
    @text = text.to_s # 数字だけのツイートでunpack('U*')がエラーを吐くので全てtoString
    @text = nil if NKF.guess(@text) != NKF::UTF8
  end

  def normalize
    @text.gsub!(/\.?\s*@[0-9A-Za-z_]+/, '')  # リプライをすべて削除
    @text.gsub!(/(RT|QT)\s*@?[0-9A-Za-z_]+.*$/, '')  # RT/QT以降行末まで削除
    @text.gsub!(/http:\/\/\S+/, '')  # URLを削除 スペースが入るまで消える
    @text.gsub!(/#[0-9A-Za-z_]+/, '')  # ハッシュタグを削除
  end

  def wakati(tagger)
    wakati_array = Array.new
    wakati_array << BEGIN_FLG
    wakati_array += tagger.wakati(@text)
    wakati_array << END_FLG

    wakati_array
  end
end
