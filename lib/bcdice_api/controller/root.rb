# frozen_string_literal: true

require_relative '../base'

module BCDiceAPI
  module Controller
    class Root < Base
      get '/' do
        'Hello. This is BCDice-API.'
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
