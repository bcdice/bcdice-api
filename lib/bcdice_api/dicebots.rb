# frozen_string_literal: true

module BCDiceAPI
  class << self
    private

    # @return [Array<Class>] ダイスボット一覧
    def load_dicebots
      list = DiceBotLoader.collectDiceBots.map(&:class)
      list.concat load_plugins
      list.push DiceBot

      list.uniq!

      list.sort_by { |dicebot| dicebot::SORT_KEY }.map { |dicebot| [dicebot::ID, dicebot] }.to_h
    end

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

  DICEBOTS = load_dicebots.freeze

  SYSTEMS = DICEBOTS.keys
                    .sort
                    .freeze

  NAMES = DICEBOTS.map { |id, dicebot| { system: id, name: dicebot::NAME } }
                  .freeze
end
