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
