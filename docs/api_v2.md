# `/v2` API詳細

## 注意事項

`/v1`ではJSONPに対応していましたが、セキュリティ上の都合により`/v2`では非対応となりました。


## Version

BCDice-APIのバージョンと、提供するBCDiceのバージョンが返却されます。

### URL

`/v2/version`

### 引数

なし

### レスポンス例

```json
{
  "api" : "2.0.0",
  "bcdice" : "3.0.0"
}
```


## Admin

BCDice-APIを提供する管理者の名前と連絡先が返却されます。

これらの設定はサーバー管理者の意図で設定されない場合があります。
設定されていない場合、各項はから空文字列 `""` となります。

### URL

`/v2/admin`

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


## Game System

BCDice-APIで利用できるゲームシステムの一覧が返却されます。
一覧は`sort_key`でソートされた状態で返却されます。

### URL

`/v2/game_system`

### 引数

なし

### レスポンス例

```json
{
  "game_system": [
    {
      "id": "DiceBot",
      "name": "DiceBot",
      "sort_key": "*たいすほつと"
    },
    {
      "id": "EarthDawn",
      "name": "アースドーン",
      "sort_key": "ああすとおん"
    },
    {
      "id": "EarthDawn3",
      "name": "アースドーン3版",
      "sort_key": "ああすとおん3"
    },
    {
      "id": "EarthDawn4",
      "name": "アースドーン4版",
      "sort_key": "ああすとおん4"
    }
  ]
}
```

### 内容

| Key        | Description |
| :--------- | :---------- |
| `id`       | ゲームシステムのID |
| `name`     | ゲームシステムの名前 |
| `sort_key` | ゲームシステムをソートするためのキー |


## Game System Info

指定したゲームシステムの詳細情報を取得します。

### URL

`/v2/game_system/{id}`

### 引数

パラメータ  | 種別        | 例         | 説明
--------- | -----       | -----     | -----
`{id}`    | URLに埋め込む | `Gorilla` | ゲームシステムのID


### レスポンス例

```json
{
  "ok": true,
  "id": "Gorilla",
  "name": "ゴリラTRPG",
  "sort_key": "こりらTRPG",
  "command_pattern": "^S?([+\\-\\dD(\\[]+|\\d+B\\d+|C|choice|D66|(repeat|rep|x)\\d+|\\d+R\\d+|\\d+U\\d+|BCDiceVersion|G.*)",
  "help_message": "2D6ロール時のゴリティカル自動判定を行います。\n\nG = 2D6のショートカット\n\n例) G>=7 : 2D6して7以上なら成功\n"
}
```

### 内容

| Key        | Description |
| :--------- | :---------- |
| `id`       | ゲームシステムのID |
| `name`     | ゲームシステムの名前 |
| `sort_key` | ゲームシステムをソートするためのキー |
| `command_pattern` | 実行可能なコマンドか判定するための正規表現。これにマッチするテキストがコマンドとして実行できる可能性がある。利用する際には大文字か小文字かを無視すること |
| `help_message` | ヘルプメッセージ |


## Dice Roll

ダイスロールを行う。GET/POSTの両方で実行可能

### URL

`/v2/game_system/{id}/roll`

### 引数

パラメータ  | 種別        | 例         | 説明
--------- | -----       | -----     | -----
`{id}`    | URLに埋め込む | `Gorilla` | ゲームシステムのID
`command` | GET/POSTパラメータ | `4d10>=15` | コマンドの文字列

### レスポンス例

```json
{
  "ok": true,
  "text": "(4D10>=15) ＞ 25[8,3,5,9] ＞ 25 ＞ 成功",
  "secret": false,
  "success": true,
  "failure": false,
  "critical": false,
  "fumble": false,
  "rands": [
    {
      "kind": "normal",
      "sides": 10,
      "value": 8
    },
    {
      "kind": "normal",
      "sides": 10,
      "value": 3
    },
    {
      "kind": "normal",
      "sides": 10,
      "value": 5
    },
    {
      "kind": "normal",
      "sides": 10,
      "value": 9
    }
  ]
}
```


### 内容

| Key        | Description |
| :--------- | :---------- |
| `text`     | コマンドの出力 |
| `secret`   | シークレットダイスか |
| `success`  | 結果が成功か |
| `failure`  | 結果が失敗か |
| `critical` | 結果がクリティカルか |
| `fumble`   | 結果がファンブルか |
| `rands`    | ダイス目の詳細。次の節を参照 |

### `rands`

| Key     | Description |
| :------ | :---------- |
| `kind`  | ダイスロールの種類。`'nomal'`, `'tens_d10'`, `'d9'`の3種類 |
| `sides` | ダイスロールしたダイスの面数 |
| `value` | 出目の値 |

#### 各kindの例

- `nomal`
  - 通常のダイスロール
  - `{"kind" : "nomal", "sides" : 10, "value" : 8}`
- `tens_d10`
  - 十の位のダイス
  - `{"kind" : "tens_d10", "sides" : 10, "value" : 80}`
  - `{"kind" : "tens_d10", "sides" : 10, "value" : 0}`
    - `00` は0として扱われます
- `d9`
  - 十面体を0〜9のダイスとして扱う
  - `{"kind" : "d9", "sides" : 10, "value" : 0}`

## Original Table

オリジナル表を実行する。POSTでのみ実行可能

### URL

`/v2/original_table`

### 引数

パラメータ | 種別          | 例    | 説明
-------- | -----        | ----- | -----
`table`  | POSTパラメータ | -     | オリジナル表のテキスト

オリジナル表の形式は[オリジナル表・BCDiceコマンドガイド](https://docs.bcdice.org/original_table.html)を参照すること

### レスポンス例

```json
{
  "ok": true,
  "text": "飲み物表(6) ＞ 選ばれし者の知的飲料",
  "rands": [
    {
      "kind": "normal",
      "sides": 6,
      "value": 6
    }
  ]
}
```

## Error

### ゲームシステムがない場合

`/v2/game_system/{id}`, `/v2/game_system/{id}/roll`

HTTP status code: 400 Bad Request

```json
{
  "ok": false,
  "reason": "unsupported game system"
}
```

### コマンドがない場合

`/v2/game_system/{id}/roll`

HTTP status code: 400 Bad Request

```json
{
  "ok": false,
  "reason": "unsupported command"
}
```
