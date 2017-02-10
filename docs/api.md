# API詳細

## version

WebAPIのバージョンと、提供するBCDiceのバージョンが返却されます。

### URL

`/v1/version`

### 引数

なし

### レスポンス例

```json
{
  "api" : "0.0.0",
  "bcdice" : "2.02.64"
}
```


## systems

WebAPIで利用できるダイスボットの一覧が返却されます。ここで得られる名前はダイスロールの実行時に利用します。ここで使われる名前は、各ダイスボットが `gameType()` で返す文字列です。

### URL

`/v1/systems`

### 引数

なし

### レスポンス例

```json
{
  "systems" : [
    "Amadeus",
    "Cthulhu",
    "DoubleCross",
    "DungeonsAndDoragons",
    "DiceBot",
    "Gorilla",
    "Gundog",
    "LogHorizon",
    "Nechronica",
    "SwordWorld2.0"
  ]
}
```

## systeminfo

パラメータで指定したダイスボットの情報（ヘルプ等）が返却されます。

### URL

`/v1/systeminfo`

### 引数

パラメータ  | 例            | 説明
----------- | ------------- | -----
`system`    | `Gorilla`     | システム名


### レスポンス例

```json
{
  "ok" : true,
  "systeminfo":{
    "name":"ゴリラTRPG",
    "gameType":"Gorilla",
    "prefixs":["G.*"],
    "info":"2D6ロール時のゴリティカル自動判定を行います。\n\nG = 2D6のショートカット\n\n例) G>=7 : 2D6して7以上なら成功\n"
  }
}
```


## diceroll

### URL

`/v1/diceroll`

### 引数

パラメータ       | 例            | 説明
---------------- | ------------- | -----
`system`         | `Cthulhu`     | システム名
`command`        | `1d100>=70`   | コマンドの文字列
`rand_results`   | `1`           | (optional)ダイス単位の結果リストを含める

### レスポンス例

```json
{
  "ok" : true,
  "result" : ": (1D100>=70) ＞ 87 ＞ 成功",
  "secret" : false
}
```

`secret` はシックレットダイスロールであるかを示します。


```json(rand_results=1指定時)
{
  "ok" : true,
  "result" : ": (4D10>=15) ＞ 20[8,2,1,9] ＞ 20 ＞ 成功",
  "secret" : false,
  "rand_results" : [[8,10],[2,10],[1,10],[9,10]]
}
```

`rand_results` はダイス単位の[出目,面数]の結果を配列で返します。


## onset

Onset! Version 2.1.2に付属しているroll.rbと同じ挙動を提供します。

### URL

`/v1/onset`

### 引数

パラメータ  | 例            | 説明
--------- | ------------- | -----
`list`  | `1`     | 対応ダイスボット一覧取得("list=1"固定)
`sys`  | `Cthulhu`     | システム名（デフォルト値`DiceBot`）
`text` | `6D10>=35`   | コマンドの文字列

### レスポンス例

```
onset: (6D10>35) ＞ 41[8,2,5,8,10,8] ＞ 41 ＞ 成功
```

