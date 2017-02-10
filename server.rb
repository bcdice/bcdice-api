# frozen_string_literal: true
$:.unshift __dir__
$:.unshift File.join(__dir__, "bcdice", "src")
$:.unshift File.join(__dir__, "lib")

require 'sinatra'
require 'sinatra/json'
require 'bcdice_wrap'

module BCDiceAPI
  VERSION = "0.1.0"
end


helpers do
  def diceroll(system, command, rand_results=nil)
    dicebot = BCDice::DICEBOTS[system]
    if dicebot.nil? || command.nil?
      return nil, nil, nil
    end

    bcdice = BCDiceMaker.new.newBcDice
    bcdice.setDiceBot(dicebot)
    bcdice.setMessage(command)
    if(rand_results.to_i == 1)
      bcdice.setCollectRandResult(true)
    end

    result, secret = bcdice.dice_command

    return result, secret, bcdice.getRandResults
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

get "/v1/systeminfo" do
  dicebot = BCDice::DICEBOTS[params[:system]]
  if dicebot.nil?
    json ok: false
  else
    json ok: true, systeminfo: dicebot.info
  end
end

get "/v1/diceroll" do
  result, secret, rand_results = diceroll(params[:system], params[:command], params[:rand_results])

  if result.nil?
    json ok: false
  elsif params[:rand_results].to_i == 1
    json ok: true, result: result, secret: secret, rand_results: rand_results
  else
    json ok: true, result: result, secret: secret
  end
end

get "/v1/onset" do
  if params[:list] == "1"
    return BCDice::SYSTEMS.join("\n")
  end

  result, secret, rand_results = diceroll(params[:sys] || "DiceBot", params[:text])

  if result.nil?
    "error"
  else
    "onset" + result
  end
end
