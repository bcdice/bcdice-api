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
  dicebot = BCDice::DICEBOTS[params[:system]]
  if dicebot.nil? || params[:command].nil?
    return json ok: false
  end
  
  bcdice = BCDiceMaker.new.newBcDice
  bcdice.setDiceBot(dicebot)
  bcdice.setMessage(params[:command])
  
  result, secret = bcdice.dice_command
  
  if result.nil?
    json ok: false
  else
    json ok: true, result: result, secret: secret
  end
end

get "/v1/OnsetCompat" do
  if params[:list] == "1"
    return BCDice::SYSTEMS.join("\n")
  end

  if params[:text]
    dicebot = BCDice::DICEBOTS[params[:sys]]
    if dicebot.nil? || params[:text].nil?
      return "error"
    end
    
    bcdice = BCDiceMaker.new.newBcDice
    bcdice.setDiceBot(dicebot)
    bcdice.setMessage(params[:text])
    
    result, secret = bcdice.dice_command
    if result.nil?
      "error"
    else
      "onset" + result
    end
  else
    return "error"
  end
end
