# frozen_string_literal: true

require_relative '../base'

module BCDiceAPI
  module Controller
    class Tester < Base
      helpers do
        def roll(id, command)
          klass = BCDiceAPI::DICEBOTS[id]
          raise UnsupportedDicebot if klass.nil?
          raise CommandError if command.nil? || command.empty?

          game_system = klass.new(command)

          result = game_system.eval
          raise CommandError if result.nil?

          {
            text: result.text,
            rands: result.detailed_rands.map(&:to_h).map{|item| item[:value]}
          }
        end
      end

      TEST_GAME_TYPE = "DiceBot"

      get "/" do
        @command = params[:command]
        game_system_id = params[:game]

        dicebot = BCDiceAPI::DICEBOTS[game_system_id] || BCDiceAPI::DICEBOTS[TEST_GAME_TYPE]
        @title = dicebot::NAME
        @id = dicebot::ID
        @help = dicebot::HELP_MESSAGE

        if @command
          begin
            @result = roll(game_system_id, @command)
          rescue CommandError
            @result = {
              text: "対応していないコマンド：#{@command}",
              rands: [],
            }
          end
        end
        erb :tester
      end

      not_found do
        json ok: false, reason: 'not found'
      end

      error do
        json ok: false
      end
    end
  end
end
