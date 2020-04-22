# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'sinatra/jsonp'
require 'sinatra/reloader' if development?
require 'bcdice_wrap'
require 'exception'

$SEND_STR_MAX = 99_999 # rubocop:disable Style/GlobalVars

module BCDiceAPI
  class App < Sinatra::Application
    class << self
      attr_accessor :test_rands
    end

    configure :production do
      set :dump_errors, false
    end

    configure :development do
      register Sinatra::Reloader
    end

    helpers Sinatra::Jsonp

    helpers do
      def diceroll(system, command)
        dicebot = BCDiceAPI::DICEBOTS[system]
        raise UnsupportedDicebot if dicebot.nil?
        raise CommandError if command.nil? || command.empty?

        bcdice = BCDiceMaker.new.newBcDice
        if App.test_rands
          bcdice.setRandomValues(App.test_rands)
          bcdice.setTest(true)
        end
        bcdice.setDiceBot(dicebot.new)
        bcdice.setMessage(command)
        bcdice.setCollectRandResult(true)

        result, secret = bcdice.dice_command

        result, secret = bcdice.try_calc_command(command) if result.nil?

        dices = bcdice.getRandResults.map { |dice| { faces: dice[1], value: dice[0] } }
        detailed_rands = bcdice.detailed_rand_results.map do |dice|
          dice = dice.to_h
          dice[:faces] = dice[:sides]
          dice.delete(:faces)

          dice
        end

        raise CommandError if result.nil?

        {
          ok: true,
          result: result,
          secret: secret,
          dices: dices,
          detailed_rands: detailed_rands
        }
      end
    end

    before do
      response.headers['Access-Control-Allow-Origin'] = '*'
    end

    get '/' do
      'Hello. This is BCDice-API.'
    end

    get '/v1/version' do
      jsonp api: BCDiceAPI::VERSION, bcdice: BCDice::VERSION
    end

    get '/v1/admin' do
      jsonp BCDiceAPI::ADMIN
    end

    get '/v1/systems' do
      jsonp systems: BCDiceAPI::SYSTEMS
    end

    get '/v1/names' do
      jsonp names: BCDiceAPI::NAMES
    end

    get '/v1/systeminfo' do
      dicebot = BCDiceAPI::DICEBOTS[params[:system]]
      raise UnsupportedDicebot if dicebot.nil?

      jsonp ok: true, systeminfo: dicebot.new.info
    end

    get '/v1/diceroll' do
      jsonp diceroll(params[:system], params[:command])
    end

    not_found do
      jsonp ok: false, reason: 'not found'
    end

    error UnsupportedDicebot do
      status 400
      jsonp ok: false, reason: 'unsupported dicebot'
    end

    error CommandError do
      status 400
      jsonp ok: false, reason: 'unsupported command'
    end

    error do
      jsonp ok: false
    end
  end
end
