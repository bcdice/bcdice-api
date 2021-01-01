# frozen_string_literal: true

require 'sinatra/jsonp'
require_relative '../base'

module BCDiceAPI
  module Controller
    class V1 < Base
      helpers Sinatra::Jsonp

      helpers do
        def diceroll(system, command)
          dicebot_klass = BCDiceAPI::DICEBOTS[system]
          raise UnsupportedDicebot if dicebot_klass.nil?
          raise CommandError if command.nil? || command.empty?

          dicebot = dicebot_klass.new(command)
          dicebot.randomizer = RandomizerMock.new(V1.test_rands) if V1.test_rands

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

      get '/version' do
        jsonp api: BCDiceAPI::VERSION, bcdice: BCDice::VERSION
      end

      get '/admin' do
        jsonp BCDiceAPI::ADMIN
      end

      get '/systems' do
        jsonp systems: BCDiceAPI::SYSTEMS
      end

      get '/names' do
        jsonp names: BCDiceAPI::NAMES
      end

      get '/systeminfo' do
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

      get '/diceroll' do
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
end
