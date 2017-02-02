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

### version

BCDiceとAPIサーバーのバージョンを取得

GET `/v1/version`


### systems

対応しているダイスボットシステム名の一覧を取得

GET `/v1/systems`

### diceroll

ダイスボットを指定してコマンドを実行する

GET `/v1/diceroll`

#### パラメータ
* `system` : システム名
* `command` : コマンド
