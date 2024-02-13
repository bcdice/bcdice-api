# BCDice-API

BCDiceを提供するWebAPIサーバー

[![Action Status](https://github.com/bcdice/bcdice-api/workflows/Test/badge.svg?branch=master)](https://github.com/bcdice/bcdice-api/actions)
[![Docker repository](https://img.shields.io/docker/pulls/bcdice/bcdice-api?logo=docker&logoColor=fff)](https://hub.docker.com/r/bcdice/bcdice-api)

## Public servers

有志によって運営されている公開サーバーの一覧

https://api-status.bcdice.org/

## What is BCDice

BCDiceは日本のTRPGセッションツールにおいて、デファクトスタンダードとも言えるダイスロールエンジンです。
初めは、Faceless氏によってPerlを用いて作成されました。後に、たいたい竹流氏によってRubyへの移植され、現在までメンテナンスされています。

BCDiceは[どどんとふ](http://www.dodontof.com)をはじめとして、[TRPGオンラインセッションSNS](https://trpgsession.click)や[Onset!](https://github.com/kiridaruma/Onset)においてダイスロールエンジンとして使われています。

## Setup

```
$ git clone https://github.com/bcdice/bcdice-api.git
$ cd bcdice-api
$ git checkout `git describe --abbrev=0` #直近のリリースに移動
$ git submodule init
$ git submodule update
$ bundle install
```

## Run

### Development

```
$ bundle exec rackup
```

### Production

```
$ APP_ENV=production bundle exec rackup -E deployment
```

実際に運用する場合には、[Puma](https://puma.io/)の利用をお勧めします。
- [Configuration](https://github.com/puma/puma#configuration)
- [設定例](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#config)

公開サーバーとして運用する場合、 `/v2/admin` の情報を設定するようにしてください。
- [/v2/admin 設定方法](/docs/api_v2.md#admin)

## API

[`/v2`](https://github.com/bcdice/bcdice-api/blob/master/docs/api_v2.md)

Method                    | Description
------------------------- | -----
/v2/version               | BCDiceとAPIサーバーのバージョン
/v2/admin                 | APIサーバ提供者の名前と連絡先
/v2/game_system           | ゲームシステムの一覧
/v2/game_system/{id}      | ゲームシステムの情報
/v2/game_system/{id}/roll | ダイスロール
/v2/original_table        | オリジナル表の実行

## Plugin

`plugins/` ディレクトリにダイスボットのコードを入れておくと、サーバー起動時にロードし、使うことができます。
既存のダイスボットを上書きすることもできます。

## Documents

- [Herokuで独自ダイスボット入りのBCDice-APIサーバーを立てる](docs/heroku.md) (中級者向け)

## Cases

- [discord-bcdicebot](https://shunshun94.github.io/discord-bcdicebot/)
- [Line botでダイスを振る - Qiita](http://qiita.com/violet2525/items/85607f2cc466a76cca07)
- [HTTPS版BCDice-API | 大ちゃんのいろいろ雑記](https://www.taruki.com/wp/?p=6610) : どどんとふ公式鯖による公開サーバー
- [オンラインセッションツール – Hotch Potch .](https://aimsot.net/tool-info/) : えいむ氏による公開サーバー

## Donate

- [Amazonほしい物リスト](http://amzn.asia/gK5kW6A)
- [Amazonギフト券](https://www.amazon.co.jp/dp/B004N3APGO/) 宛先: ysakasin@gmail.com

## The Auther

酒田　シンジ (@ysakasin)
