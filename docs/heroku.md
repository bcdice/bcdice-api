# Herokuへの設置

このドキュメントでは[Heroku](https://jp.heroku.com/)を用いて、**無料で**独自ダイスボット入りのBCDice-APIサーバーの建て方を解説します。ツールの制約により、コマンドラインを用いる必要があるため中級者向けの資料となっています。


## 対象読者
- コマンドラインが使える
- Gitを使ったことがある/使えるようになる
- 英語のWebサイトで怯まない


## 大まかな流れ

- Herokuのアカウント登録
  - Heroku CLIでの認証
- BCDice-APIの修正
  - 独自ダイスボットを記述したコードの追加
  - commit
- Herokuにデプロイ


## Herokuとは

HerokuはクラウドプラットフォームやPaaSと呼ばれるもので、VPSと比べてアプリケーションの設置や管理を容易に行うことができます。
Herokuでは[無料プラン](https://jp.heroku.com/pricing)が用意されており、独自サーバーを試しやすくなっています。

Herokuでは動作させるアプリケーションをGitで管理・送信する必要があり、このドキュメントでもGitを用います。


## 使うツール

はじめに、このドキュメントで使うツールを列挙します。

- コマンドライン
- Git
- GitHub
- Heroku
- Heroku CLI

コマンドラインを用いてアプリケーションの設置を行います。
残念ながら、ドキュメント執筆時点ではコマンドラインを用いずにHerokuへBCDice-APIを設置することができません。


## 1. 各種アカウントの作成

Herokuにアプリケーションを設置するにはアカウントが必要です。
下記リンクからアカウント登録を行ってください。

- [Heroku | 新規登録](https://signup.heroku.com/jp)


## 2. ツールのインストール

下記ドキュメントを参考に、Heroku CLIおよびGitのインストールを行ってください。

- [The Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
- [Git - Gitのインストール](https://git-scm.com/book/ja/v2/%E4%BD%BF%E3%81%84%E5%A7%8B%E3%82%81%E3%82%8B-Git%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)


## 3. Heroku CLIのセットアップ

Heroku CLIをインストールしたら、ログインを行います。
コマンドラインで以下のように入力し、表示される指示に従ってログインします。

```
heroku login
```

## 4. BCDice-APIにダイスボットを注入

BCDice-APIでは `plugins/` にコードをいれておくと、読み込むようになっています。
BCDiceにないゲームシステムに対応するには、この機能を活用します。

まず、BCDice-APIをcloneします。

```
git clone https://github.com/ysakasin/bcdice-api
```

Cloneしたファイルの中にある `plugins/` ディレクトリにダイスボットのコードをいれておきます。
そして、下記コマンドで変更を確定(commit)させます。

```
git add plugins/
git commit
```

ここまでで独自ダイスボットを内臓したBCDice-APIを手元に構築できました。


## 5. Herokuへのデプロイ

`bcdice-api` のディレクトリにいる状態で、以下のコマンドでHeroku上に場所を確保します。この時、 `https://thawing-inlet-61413.herokuapp.com/` のように、このアプリのURLが表示されるのでメモしておきましょう。

```
heroku create
```

上記の作業で手元のgitリポジトリに、`heroku`というリモートが追加されています。
これにpushするとアプリケーションをHerokuにデプロイでいます。
pushは以下のようにして行います。

```
git push heroku master
```

これで独自サーバーの設置が完了です。
先ほどメモしたURLにブラウザからアクセスして、以下のように表示されればOKです。

```
Hello. This is BCDice-API.
```


## わからない時には

[GitHub issues](https://github.com/ysakasin/bcdice-api/issues)や私の[Twitter](https://twitter.com/ysakasin)に困っていることを教えてください。
可能な限りサポートします。


## ex. 支援

2019年現在、様々なオンセツールが有志によって開発されており、その多くが無料で使うことができます。
このBCDice-APIも、[たいたい竹流](https://twitter.com/torgtaitai)さんが作成したBCDiceを用いております。
気に入ったツールがあれば、Amazonギフト券等の支援をぜひお願いいたします。
ツール開発の励みになることと思います。

### TRPGオンセツール支援方法まとめ
- [TRPGオンセツール開発者、貢献者とその支援窓口いろいろ – 大ちゃんのいろいろ雑記](https://www.taruki.com/wp/?page_id=6720)

### 酒田　シンジへの支援
- [Amazonほしい物リスト](http://amzn.asia/gK5kW6A)
- [Amazonギフト券](https://www.amazon.co.jp/Amazonギフト券-Eメールタイプ/dp/BT00DHI8G) 宛先: donate@sakasin.net
