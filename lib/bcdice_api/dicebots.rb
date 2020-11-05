# frozen_string_literal: true

require 'bcdice'
require 'bcdice/game_system'

module BCDiceAPI
  class << self
    private

    # @return [Array<Class>] 追加のダイスボット
    def load_plugins
      query = File.join(__dir__, '../../plugins', '*.rb')

      Dir.glob(query).map do |plugin|
        id = File.basename(plugin, '.rb')

        require "plugins/#{id}"
        Object.const_get(id)
      end
    end
  end

  DICEBOTS = BCDice.all_game_systems.map { |klass| [klass::ID, klass] }.to_h

  SYSTEMS = DICEBOTS.keys
                    .sort
                    .freeze

  NAMES = DICEBOTS.map do |id, dicebot|
    { system: id, name: dicebot::NAME, sort_key: dicebot::SORT_KEY }
  end.freeze
end
