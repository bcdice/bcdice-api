# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'

require 'sinatra/reloader' if development?

require 'bcdice/user_defined_dice_table'

module BCDiceAPI
  module V2
    class App < Sinatra::Base
      class << self
        attr_accessor :test_rands
      end

      before do
        response.headers['Access-Control-Allow-Origin'] = '*'
      end

      helpers do
        def roll(id, command)
          klass = BCDiceAPI::DICEBOTS[id]
          raise UnsupportedDicebot if klass.nil?
          raise CommandError if command.nil? || command.empty?

          game_system = klass.new(command)
          game_system.randomizer = RandomizerMock.new(App.test_rands) if App.test_rands

          result = game_system.eval
          raise CommandError if result.nil?

          {
            ok: true,
            text: result.text,
            secret: result.secret?,
            success: result.success?,
            failure: result.failure?,
            critical: result.critical?,
            fumble: result.fumble?,
            rands: result.detailed_rands.map(&:to_h)
          }
        end
      end

      get '/v2/version' do
        json api: BCDiceAPI::VERSION, bcdice: BCDice::VERSION
      end

      get '/v2/admin' do
        json BCDiceAPI::ADMIN
      end

      get '/v2/game_system' do
        game_system = BCDice.all_game_systems.sort_by { |game| game::SORT_KEY } .map do |game|
          { id: game::ID, name: game::NAME, sort_key: game::SORT_KEY }
        end

        json game_system: game_system
      end

      get '/v2/game_system/:id' do |id|
        game_system = BCDice.game_system_class(id)
        raise UnsupportedDicebot if game_system.nil?

        ret = {
          ok: true,
          id: game_system::ID,
          name: game_system::NAME,
          sort_key: game_system::SORT_KEY,
          command_pattern: game_system.command_pattern.source,
          help_message: game_system::HELP_MESSAGE
        }

        json ret
      end

      get '/v2/game_system/:id/roll' do |id|
        json roll(id, params[:command])
      end

      post '/v2/game_system/:id/roll' do |id|
        json roll(id, params[:command])
      end

      post '/v2/original_table' do
        table = BCDice::UserDefinedDiceTable.new(params[:table])
        result = table.roll

        json ok: true, text: result.text, rands: result.detailed_rands.map(&:to_h)
      end

      error UnsupportedDicebot do
        status 400
        json ok: false, reason: 'unsupported game system'
      end

      error CommandError do
        status 400
        json ok: false, reason: 'unsupported command'
      end
    end
  end
end
