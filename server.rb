# frozen_string_literal: true
$:.unshift __dir__
$:.unshift File.join(__dir__, "bcdice", "src")
$:.unshift File.join(__dir__, "lib")

require 'sinatra'
require 'sinatra/jsonp'
require 'bcdice_wrap'

module BCDiceAPI
  VERSION = "0.3.0"
end


helpers do
  def diceroll(system, command)
    dicebot = BCDice::DICEBOTS[system]
    if dicebot.nil? || command.nil?
      return nil, nil, nil
    end

    bcdice = BCDiceMaker.new.newBcDice
    bcdice.setDiceBot(dicebot)
    bcdice.setMessage(command)
    bcdice.setDir("bcdice/extratables",system)
    bcdice.setCollectRandResult(true)

    result, secret = bcdice.dice_command
    dices = bcdice.getRandResults.map {|dice| {faces: dice[1], value: dice[0]}}

    return result, secret, dices
  end
end

get "/" do
  "Hello. This is BCDice-API."
end

get "/v1/version" do
  jsonp api: BCDiceAPI::VERSION, bcdice: BCDice::VERSION
end

get "/v1/systems" do
  jsonp systems: BCDice::SYSTEMS
end

get "/v1/systeminfo" do
  dicebot = BCDice::DICEBOTS[params[:system]]
  if dicebot.nil?
    status 400
    jsonp ok: false
  else
    jsonp ok: true, systeminfo: dicebot.info
  end
end

get "/v1/diceroll" do
  result, secret, dices = diceroll(params[:system], params[:command])

  if result.nil?
    status 400
    jsonp ok: false
  else
    jsonp ok: true, result: result, secret: secret, dices: dices
  end
end

get "/v1/onset" do
  if params[:list] == "1"
    return BCDice::SYSTEMS.join("\n")
  end

  result, secret, dices = diceroll(params[:sys] || "DiceBot", params[:text])

  if result.nil?
    "error"
  else
    "onset" + result
  end
end
