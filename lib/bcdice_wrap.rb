# frozen_string_literal: true
require "bcdiceCore"
require "diceBot/DiceBot"
require "diceBot/DiceBotLoader"

class BCDice
  VERSION = "2.02.70"
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

IGNORE_CODES = [
  'DiceBotLoader.rb',
  'DiceBotLoaderList.rb',
  'baseBot.rb',
  '_Template.rb',
  'test.rb'
].freeze

Dir.glob("bcdice/src/diceBot/*.rb").each do |path|
  if IGNORE_CODES.include?(File.basename(path))
    next
  end
  require path
  klass = Module.const_get(File.basename(path, ".rb"))
  dicebot = klass.new
  BCDice::DICEBOTS[dicebot.gameType] = dicebot
  BCDice::SYSTEMS << dicebot.gameType
end

BCDice::SYSTEMS.sort!

BCDice::DICEBOTS.freeze
BCDice::SYSTEMS.freeze
