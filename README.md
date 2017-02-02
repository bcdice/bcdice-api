# BCDice-API

BCDiceを提供するAPIサーバー

## Demo

https://bcdice.herokuapp.com/v1/version

## Setup

```
$ git clone https://github.com/NKMR6194/bcdice-api.git
$ cd bcdice-api
$ git submodule init
$ git submodule update
$ bundle install
$ bundle exec ruby server.rb
```

## API

Method                           | Description
-------------------------------- | ----- 
[/v1/version](/api.md#version)   | BCDiceとAPIサーバーのバージョン
[/v1/systems](/api.md#systems)   | ダイスボットのシステム名一覧
[/v1/diceroll](/api.md#diceroll) | ダイスボットのコマンドを実行
