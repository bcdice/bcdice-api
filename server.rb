# frozen_string_literal: true
$:.unshift __dir__
$:.unshift File.join(__dir__, "bcdice", "src")
$:.unshift File.join(__dir__, "lib")

require 'sinatra'
require 'sinatra/json'
require 'bcdice_wrap'

module BCDiceAPI
  VERSION = "0.0.0"
end


helpers do
  def diceroll(system, command)
    dicebot = BCDice::DICEBOTS[system]
    if dicebot.nil? || command.nil?
      return nil, nil
    end

    bcdice = BCDiceMaker.new.newBcDice
    bcdice.setDiceBot(dicebot)
    bcdice.setMessage(command)

    return bcdice.dice_command
  end
end

get "/" do
  "Hello. This is BCDice-API."
end

get "/v1/version" do
  json api: BCDiceAPI::VERSION, bcdice: BCDice::VERSION
end

get "/v1/systems" do
  json systems: BCDice::SYSTEMS
end

get "/v1/diceroll" do
  result, secret = diceroll(params[:system], params[:command])

  if result.nil?
    json ok: false
  else
    json ok: true, result: result, secret: secret
  end
end

get "/v1/onset" do
  if params[:list] == "1"
    return BCDice::SYSTEMS.join("\n")
  end

  result, secret = diceroll(params[:sys] || "DiceBot", params[:text])

  if result.nil?
    "error"
  else
    "onset" + result
  end
end
