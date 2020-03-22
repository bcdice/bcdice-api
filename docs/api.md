# API詳細

JSONを返却する全てのAPIはJSONPに対応しています。


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
  "admin" : {
    "name": "user-name",
    "address": "https://your-information-page/url"
  }
}
```


## systems

WebAPIで利用できるダイスボットのシステムID一覧が返却されます。システムIDは、各ダイスボットが `gameType()` で返す文字列で、ダイスロールの実行時に利用します。

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


## names

システムIDとシステム名の一覧が返却されます。

### URL

`/v1/names`

### 引数

なし

### レスポンス例

```json
{
  "names": [
    {"system": "Alshard", "name": "アルシャード"},
    {"system": "Cthulhu", "name": "クトゥルフ"},
    {"system": "DiceBot", "name": "DiceBot"},
    {"system": "DoubleCross", "name": "ダブルクロス2nd,3rd"},
    {"system": "DungeonsAndDoragons", "name": "ダンジョンズ＆ドラゴンズ"},
    {"system": "Gorilla", "name": "ゴリラTRPG"},
    {"system": "Gundog", "name": "ガンドッグ"},
    {"system": "LogHorizon", "name": "ログ・ホライズン"},
    {"system": "Nechronica", "name": "ネクロニカ"},
    {"system": "SwordWorld2.0", "name": "ソードワールド2.0"}
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
`system`    | `Gorilla`     | システムID


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
`system`         | `Cthulhu`     | システムID
`command`        | `4d10>=15`   | コマンドの文字列

### レスポンス例

```json
{
  "ok" : true,
  "result" : ": (4D10>=15) ＞ 20[8,2,1,9] ＞ 20 ＞ 成功",
  "secret" : false,
  "dices" : [
    {"faces" : 10, "value" : 8},
    {"faces" : 10, "value" : 2},
    {"faces" : 10, "value" : 1},
    {"faces" : 10, "value" : 9},
  ]
}
```

`secret` はシックレットダイスロールであるかを示します。
`dices` はダイス単位の結果を配列で返します。
