# BCDice-API

BCDiceを提供するAPIサーバー

## Demo

https://bcdice.herokuapp.com

## Setup

```
$ git clone https://github.com/NKMR6194/bcdice-api.git
$ cd bcdice-api
$ git submodule init
$ git submodule update
$ bundle install
$ bundle exec rackup
```

## API

Method                           | Description
-------------------------------- | ----- 
[/v1/version](/docs/api.md#version)   | BCDiceとAPIサーバーのバージョン
[/v1/systems](/docs/api.md#systems)   | ダイスボットのシステム名一覧
[/v1/diceroll](/dosc/api.md#diceroll) | ダイスボットのコマンドを実行
[/v1/onset](/dosc/api.md#onset)       | Onset!互換
