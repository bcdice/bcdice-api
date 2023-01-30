# frozen_string_literal: true

require 'bcdice/user_defined_dice_table'
require_relative '../base'

module BCDiceAPI
  module Controller
    class V2 < Base
      helpers do
        def roll(id, command)
          klass = BCDiceAPI::DICEBOTS[id]
          raise UnsupportedDicebot if klass.nil?
          raise CommandError if command.nil? || command.empty?

          game_system = klass.new(command)
          game_system.randomizer = RandomizerMock.new(V2.test_rands) if V2.test_rands

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

      get '/version' do
        json api: BCDiceAPI::VERSION, bcdice: BCDice::VERSION
      end

      get '/admin' do
        json BCDiceAPI::ADMIN
      end

      get '/game_system' do
        game_system = BCDice.all_game_systems.sort_by { |game| game::SORT_KEY }.map do |game|
          { id: game::ID, name: game::NAME, sort_key: game::SORT_KEY }
        end

        json game_system: game_system
      end

      get '/game_system/:id' do |id|
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

      get '/game_system/:id/roll' do |id|
        json roll(id, params[:command])
      end

      post '/game_system/:id/roll' do |id|
        json roll(id, params[:command])
      end

      post '/original_table' do
        table = BCDice::UserDefinedDiceTable.new(params[:table])
        result = table.roll

        json ok: true, text: result.text, rands: result.detailed_rands.map(&:to_h)
      end

      not_found do
        json ok: false, reason: 'not found'
      end

      error UnsupportedDicebot do
        status 400
        json ok: false, reason: 'unsupported game system'
      end

      error CommandError do
        status 400
        json ok: false, reason: 'unsupported command'
      end

      error do
        json ok: false
      end
    end
  end
end
