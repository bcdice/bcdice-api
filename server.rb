# frozen_string_literal: true
require 'sinatra'
require 'sinatra/json'

$LOAD_PATH << __dir__
$LOAD_PATH << __dir__+"/bcdice/src/"

module BCDiceAPI
  VERSION = "0.0.0"
end

class BCDice
  VERSION = "2.02.64"
  SYSTEMS = []
  DICEBOTS = {}
end

require "diceBot/DiceBot"

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

require "bcdiceCore"

class BCDice
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

    output = nil
    secret = nil
    return output, secret
  end
end

get "/" do
  "Hello. This is DCDice-API."
end

get "/v1/version" do
  json api: BCDiceAPI::VERSION, bcdice: BCDice::VERSION
end

get "/v1/systems" do
  json systems: BCDice::SYSTEMS
end

get "/v1/diceroll" do
  bcdice = BCDiceMaker.new.newBcDice
  bcdice.setDiceBot(BCDice::DICEBOTS[params[:system]])
  bcdice.setMessage(params[:command])

  result, secret = bcdice.dice_command

  if result.nil?
    json ok: false
  else
    json ok: true, result: result, secret: secret
  end
end
