マルコフ連鎖をやってみました。

1人のユーザの過去ツイートから適当にしゃべります。

とりあえずTwitter公式から今までのツイートをDLして、そのCSVを使うだけ。

## Usage
1. Twitter公式から全ツイート履歴をDL
2. [igo-ruby](https://github.com/kyow/igo-ruby)をインストール
3. [Twitter Ruby Gem](https://github.com/sferik/twitter)をインストール
4. `ruby tweet.rb`

### 実行サンプル
- [@yootakuti](https://twitter.com/yootakuti)
- markov.rbを30分に1回実行してる

## About Reply
- 最初だけ、botアカウントのmentionsのうち最新のもの1ツイートのIDをlatest_mention_id.txtに書き込んであげる
- mentionsが1つもない場合は0でも入れておく
- 以後 `ruby reply.rb` を実行する度に自動的にアップデートされる

**latest\_mention\_id.txtの中身の例**
`356989334773170176`

## TODO
- 最新ツイートの自動取得
- 外部ファイル(latest_mention_id.txt)に頼らないリプライ対応
- 処理速度向上（今のだと、ツイート数が5万弱でおよそ1分かかります）

