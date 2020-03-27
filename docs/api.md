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
}
```


## admin

WebAPIを提供する管理者の名前と連絡先が返却されます。

これらの設定はサーバー管理者の意図で設定されない場合があります。
設定されていない場合、各項はから空文字列 `""` となります。

### URL

`/v1/admin`

### 引数

なし

### レスポンス例

```json
{
  "name": "user-name",
  "url": "https://your-information-page/url",
  "email": "your@email.address"
}
```

### 内容

| Key   | Description |
| :---- | :---------- |
| `name`  | 管理者の名前 |
| `url`   | 利用規約等が書かれたページのURL |
| `email` | 連絡先メールアドレス |

### 設定方法

設定方法は２種類あります。優先度は 環境変数 > 設定ファイル です。

#### 1. 設定ファイル

`config/admin.yaml` を設置します。内容は `config/admin.yaml.example` を参考にしてください。

#### 2. 環境変数

| ENV                      | JSON key |
| :----------------------- | :------- |
| `BCDICE_API_ADMIN_NAME`  | `name`   |
| `BCDICE_API_ADMIN_URL`   | `url`    |
| `BCDICE_API_ADMIN_EMAIL` | `email`  |


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
    {"faces" : 10, "value" : 9}
  ],
  "detailed_rands" : [
    {"kind" : "nomal", "faces" : 10, "value" : 8},
    {"kind" : "nomal", "faces" : 10, "value" : 2},
    {"kind" : "nomal", "faces" : 10, "value" : 1},
    {"kind" : "nomal", "faces" : 10, "value" : 9}
  ]
}
```

`secret` はシックレットダイスロールであるかを示します。
`dices` はダイス単位の結果を配列で返します。

### `detailed_rands`
`detailed_rands` は `dices` より詳細なダイスロール結果を表示します。
従来は判別できなかった、十の位のダイス（Tens D10）を判別するために追加されました。

例は以下の通りです。

- `nomal`
  - 通常のダイスロール
  - `{"kind" : "nomal", "faces" : 10, "value" : 8}`
- `tens_d10`
  - 十の位のダイス
  - `{"kind" : "tens_d10", "faces" : 10, "value" : 80}`
  - `{"kind" : "tens_d10", "faces" : 10, "value" : 0}`
    - `00` は0として扱われます
- `d9`
  - 十面体を0〜9のダイスとして扱う
  - `{"kind" : "d9", "faces" : 10, "value" : 0}`

Since: 0.9.0, BCDice Ver2.04.00
