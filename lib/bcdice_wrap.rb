require "bcdiceCore"
require "diceBot/DiceBot"

class BCDice
  VERSION = "2.02.64"
  SYSTEMS = []
  DICEBOTS = {}

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

    output, secret = getTableDataResult(arg)
    return output, secret unless( output.nil? )

    output = nil #BCDiceからの変更点
    secret = nil
    return output, secret
  end
end

Dir.glob("bcdice/src/diceBot/*.rb").each do |path|
  if ["_Template.rb", "test.rb", "DiceBotLoader.rb"].include?(File.basename(path))
    next
  end
  require path
  klass = Module.const_get(File.basename(path, ".rb"))
  dicebot = klass.new
  BCDice::DICEBOTS[dicebot.gameType] = dicebot
  BCDice::SYSTEMS << dicebot.gameType
end

BCDice::DICEBOTS.freeze
BCDice::SYSTEMS.freeze
