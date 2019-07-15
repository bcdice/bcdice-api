# frozen_string_literal: true
require "bcdiceCore"
require "diceBot/DiceBot"
require "diceBot/DiceBotLoader"

class BCDice
  DICEBOTS = (DiceBotLoader.collectDiceBots + [DiceBot.new]).
    map { |diceBot| [diceBot.gameType, diceBot] }.
    sort.
    to_h.
    freeze

  SYSTEMS = DICEBOTS.keys.
    sort.
    freeze

  NAMES = DICEBOTS.
    map { |gameType, diceBot| {system: gameType, name: diceBot.gameName} }.
    freeze

  # 与えられた文字列が計算コマンドのようであるかを返す
  # @param [String] s 調べる文字列
  # @return [true] sが計算コマンドのようであった場合
  # @return [false] sが計算コマンドではない場合
  #
  # 詳細な構文解析は行わない。
  # 計算コマンドで使われ得る文字のみで構成されているかどうかだけを調べる。
  def self.seem_to_be_calc?(s)
    # 空白が含まれる場合、最初の部分だけを取り出す
    target = s.split(/\s/, 2).first

    return %r{\AC\([-+*/()\d]+\)\z}i === target
  end

  def dice_command   # ダイスコマンドの分岐処理
    arg = @message.upcase

    debug('dice_command arg', arg)

    output, secret = @diceBot.dice_command(@message, @nick_e)
    return output, secret if( output != '1' )

    output, secret = rollD66(arg)
    return output, secret unless( output.nil? )

    output, secret = checkAddRoll(arg)
    return output, secret unless( output.nil? )

    output, secret = checkBDice(arg)
    return output, secret unless( output.nil? )

    output, secret = checkRnDice(arg)
    return output, secret unless( output.nil? )

    output, secret = checkUpperRoll(arg)
    return output, secret unless( output.nil? )

    output, secret = checkChoiceCommand(arg)
    return output, secret unless( output.nil? )

    output = nil #BCDiceからの変更点
    secret = nil
    return output, secret
  end

  # 計算コマンドの実行を試みる
  # @return [Array<String, false>] 計算コマンドの実行に成功した場合
  # @return [nil, nil] 計算コマンドの実行に失敗した場合
  #
  # 返り値の2つ目の要素は、`result, secret =` と受け取れるようにするために
  # 用意している。
  def try_calc_command
    stripped_message = @message.strip
    matches = stripped_message.match(/\AC([-\d]+\z)/i)

    if matches.nil?
      return nil, nil
    end

    calc_result = matches[1]
    return "#{@diceBot.gameType} : 計算結果 ＞ #{calc_result}", false
  end
end

class DiceBot
  def getHelpMessage
    return <<INFO_MESSAGE_TEXT
【ダイスボット】チャットにダイス用の文字を入力するとダイスロールが可能
入力例）２ｄ６＋１　攻撃！
出力例）2d6+1　攻撃！
　　　　  diceBot: (2d6) → 7
上記のようにダイス文字の後ろに空白を入れて発言する事も可能。
以下、使用例
　3D6+1>=9 ：3d6+1で目標値9以上かの判定
　1D100<=50 ：D100で50％目標の下方ロールの例
　3U6[5] ：3d6のダイス目が5以上の場合に振り足しして合計する(上方無限)
　3B6 ：3d6のダイス目をバラバラのまま出力する（合計しない）
　10B6>=4 ：10d6を振り4以上のダイス目の個数を数える
　(8/2)D(4+6)<=(5*3)：個数・ダイス・達成値には四則演算も使用可能
　C(10-4*3/2+2)：C(計算式）で計算だけの実行も可能
　choice[a,b,c]：列挙した要素から一つを選択表示。ランダム攻撃対象決定などに
　S3d6 ： 各コマンドの先頭に「S」を付けると他人結果の見えないシークレットロール
　3d6/2 ： ダイス出目を割り算（切り捨て）。切り上げは /2U、四捨五入は /2R。
　D66 ： D66ダイス。順序はゲームに依存。D66N：そのまま、D66S：昇順。
INFO_MESSAGE_TEXT
  end
end
