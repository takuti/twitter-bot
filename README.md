***Sorry, this project is strongly optimized for Japanese tweets. So, README and comments in the source code are written in Japanese :(***

## なにこれ

- 過去ツイートからマルコフ連鎖でツイートを生成します
- サンプル：[@yootakuti](https://twitter.com/yootakuti)
- 解説：[マルコフ連鎖でTwitter Botをつくりました - blog.takuti.me](http://blog.takuti.me/twitter-bot/) 

## 使い方

1. Twitter公式から過去ツイートをダウンロード
	- ディレクトリ **data/** に配置
	- **data/tweets/tweets.csv** の *text* カラムを使う
2. 形態素解析用に [igo-ruby](https://github.com/kyow/igo-ruby) を準備
	- 辞書のディレクトリは **ipadic/**
3. ツイート生成/投稿
	- とりあえず1つ生成してみたい場合は `ruby main.rb`
	- 投稿したい場合は **main.rb** でキーとか書いて `ruby main.rb production`

## リプライ

***開発中なのでまだ正しく動作しません***

- **reply.rb** は [Twitter Ruby Gem](https://github.com/sferik/twitter) のストリーミング機能で自分宛てのリプライを拾ってツイート生成して返信する
- デーモン
	- 起動：`ruby reply.rb`
	- 終了：`cat reply_daemon.pid | xargs kill`
	- **reply_daemon.pid** はデーモン起動時に自動で作成される
	- 参考：[http://nuke.hateblo.jp/entry/2013/07/04/090917](http://nuke.hateblo.jp/entry/2013/07/04/090917)

## おまけ

生成されたツイートの文字数が100文字を超えた場合、長すぎてグダグダな文章になるので代わりに顔文字を投稿します。[kaomoji.html](https://github.com/tatat/kaomoji.html) のAPIを使っています。

## TODO

- ツイート生成の度に1から（形態素解析から）処理を行なっているので毎回1分くらい時間がかかってムダ
- もっと人間っぽいツイートの生成
- リプライ機能ちゃんと実装する