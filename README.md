# BCDice-API

BCDiceを提供するWebAPIサーバー

[![Build Status](https://travis-ci.org/ysakasin/bcdice-api.svg?branch=master)](https://travis-ci.org/ysakasin/bcdice-api)

## Demo

https://bcdice.herokuapp.com

## What is BCDice

BCDiceは日本のTRPGセッションツールにおいて、デファクトスタンダードとも言えるダイスロールエンジンです。
初めは、Faceless氏によってPerlを用いて作成されました。後に、たいたい竹流氏によってRubyへの移植され、現在までメンテナンスされています。

BCDiceは[どどんとふ](http://www.dodontof.com)をはじめとして、[TRPGオンラインセッションSNS](https://trpgsession.click)や[Onset!](https://github.com/kiridaruma/Onset)においてダイスロールエンジンとして使われています。

## Setup

```
$ git clone https://github.com/ysakasin/bcdice-api.git
$ cd bcdice-api
$ git checkout `git describe --abbrev=0` #直近のリリースに移動
$ git submodule init
$ git submodule update
$ bundle install
$ bundle exec rackup
```

実際に運用する場合には、UnicornやPumaの利用をお勧めします。（[参考資料](http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn)）

## API

Method                           | Description
-------------------------------- | -----
[/v1/version](/docs/api.md#version)   | BCDiceとAPIサーバーのバージョン
[/v1/systems](/docs/api.md#systems)   | ダイスボットのシステム名一覧
[/v1/systeminfo](/docs/api.md#systeminfo)   | ダイスボットのシステム情報取得
[/v1/diceroll](/docs/api.md#diceroll) | ダイスボットのコマンドを実行
[/v1/onset](/docs/api.md#onset)       | Onset!互換

## Cases

- [discord-bcdicebot](https://shunshun94.github.io/discord-bcdicebot/)
- [Line botでダイスを振る - Qiita](http://qiita.com/violet2525/items/85607f2cc466a76cca07)
- [HTTPS版BCDice-API | 大ちゃんのいろいろ雑記](https://www.taruki.com/wp/?p=6610) : どどんとふ公式鯖による公開サーバー
- [オンラインセッションツール – Hotch Potch .](https://aimsot.net/tool-info/) : えいむ氏による公開サーバー

## Donate

- [Amazonほしい物リスト](http://amzn.asia/gK5kW6A)
- [Amazonギフト券](https://www.amazon.co.jp/Amazonギフト券-Eメールタイプ/dp/BT00DHI8G) 宛先: donate@sakasin.net

## The Auther

酒田　シンジ (@ysakasin)
