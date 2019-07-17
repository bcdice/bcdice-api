## 0.7.0

- 計算コマンドに対応 (thanks @ochaochaocha3)


## 0.6.3

- BCDice Ver2.03.01 にアップデート
- 不要な処理の削除

## 0.6.2

- BCDice Ver2.02.80 にアップデート
- 不要な処理の削除

## 0.6.1

- BCDice Ver2.02.79 にアップデート
- 依存Gemのアップデート
- Ruby 2.6をサポート対象に
- Ruby 2.2をサポート対象外に

## 0.6.0

- `/v1/names` を追加 ([Document](/docs/api.md#names))
- CORSに対応


## 0.5.3

- Production実行時にはエラーログにバックトレースを出力しない
- `command` パラメータが空だった場合のエラー処理を修正

## 0.5.2

- BCDice Ver2.02.76 にアップデート
- Sinatra 2.0.0 の脆弱性発見に伴い、依存Gemの更新
- [for developer] Ruby 2.5.0での動作確認

## 0.5.1

- BCDice Ver2.02.73 にアップデート
- Sinatra 2.0 に更新
- 依存するその他のGemのバージョンを更新

## 0.5.0

- BCDice Ver2.02.72 にアップデート
- 処理の一部を最適化 (thanks @ochaochaocha3)


## 0.4.0

- JSONPに対応
- 失敗時に妥当なHTTPステータスコードを示すように
- 失敗時のレスポンスに `reason` を追加
- DiceBotのsysteminfoで標準ダイスボットのヘルプを返すように
- Herokuに直接デプロイできるように設定を記述
- [for developer] テストコードを作成


## 0.3.0

- BCDice Ver2.02.70 にアップデート
- extratablesに対応 (thanks @kumakaba)


## 0.2.0

- `/v1/systeminfo` (thanks @kumakaba)
- `/v1/diceroll`でダイスごとの結果を返すように (thanks @kumakaba)


## 0.1.0

- `/v1/version`
- `/v1/systems`
- `/v1/diceroll`
- `/v1/onset` (thanks @daicyan)
