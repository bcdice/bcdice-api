# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'sinatra/jsonp'
require 'sinatra/reloader' if development?
require 'exception'

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
        dicebot_klass = BCDiceAPI::DICEBOTS[system]
        raise UnsupportedDicebot if dicebot_klass.nil?
        raise CommandError if command.nil? || command.empty?

        dicebot = dicebot_klass.new(command)
        dicebot.randomizer = RandomizerMock.new(App.test_rands) if App.test_rands

        result = dicebot.eval

        raise CommandError if result.nil?

        dices = result.rands.map { |dice| { faces: dice[1], value: dice[0] } }
        detailed_rands = result.detailed_rands.map(&:to_h)

        {
          ok: true,
          result: ": #{result.text}",
          secret: result.secret?,
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

      systeminfo = {
        'name' => dicebot::NAME,
        'gameType' => dicebot::ID,
        'sortKey' => dicebot::SORT_KEY,
        'prefixs' => dicebot.prefixes,
        'info' => dicebot::HELP_MESSAGE
      }

      jsonp ok: true, systeminfo: systeminfo
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
