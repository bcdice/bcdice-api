# BCDice-API

BCDiceを提供するWebAPIサーバー

## Demo

https://bcdice.herokuapp.com

## Setup

```
$ git clone https://github.com/NKMR6194/bcdice-api.git
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
