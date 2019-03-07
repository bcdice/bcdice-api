# frozen_string_literal: true
$:.unshift __dir__
$:.unshift File.join(__dir__, "bcdice", "src")
$:.unshift File.join(__dir__, "lib")

require 'sinatra'
require 'sinatra/jsonp'
require 'bcdice_wrap'
require 'exception'

module BCDiceAPI
  VERSION = "0.6.1"
end

configure :production do
  set :dump_errors, false
end

helpers do
  def diceroll(system, command)
    dicebot = BCDice::DICEBOTS[system]
    if dicebot.nil?
      raise UnsupportedDicebot
    end
    if command.nil? || command.empty?
      raise CommandError
    end

    bcdice = BCDiceMaker.new.newBcDice
    bcdice.setDiceBot(dicebot)
    bcdice.setMessage(command)
    bcdice.setDir("bcdice/extratables",system)
    bcdice.setCollectRandResult(true)

    result, secret = bcdice.dice_command
    dices = bcdice.getRandResults.map {|dice| {faces: dice[1], value: dice[0]}}

    if result.nil?
      raise CommandError
    end

    return result, secret, dices
  end
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
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

get "/v1/names" do
  jsonp names: BCDice::NAMES
end

get "/v1/systeminfo" do
  dicebot = BCDice::DICEBOTS[params[:system]]
  if dicebot.nil?
    raise UnsupportedDicebot
  end

  jsonp ok: true, systeminfo: dicebot.info
end

get "/v1/diceroll" do
  result, secret, dices = diceroll(params[:system], params[:command])

  jsonp ok: true, result: result, secret: secret, dices: dices
end

get "/v1/onset" do
  if params[:list] == "1"
    return BCDice::SYSTEMS.join("\n")
  end

  begin
    result, secret, dices = diceroll(params[:sys] || "DiceBot", params[:text])
    "onset" + result
  rescue UnsupportedDicebot, CommandError
    "error"
  end
end

not_found do
  jsonp ok: false, reason: "not found"
end

error UnsupportedDicebot do
  status 400
  jsonp ok: false, reason: "unsupported dicebot"
end

error CommandError do
  status 400
  jsonp ok: false, reason: "unsupported command"
end

error do
  jsonp ok: false
end
