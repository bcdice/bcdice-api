# frozen_string_literal: true

module BCDiceAPI
  class RandomizerMock < BCDice::Randomizer
    def initialize(rands)
      super()
      @rands = rands
    end

    def random(sides)
      dice, expected_sides = @rands.shift

      raise '@rands is empty!' if dice.nil?

      if sides != expected_sides
        raise "unexpected sides at [#{dice}/#{expected_sides}], side" \
              " (given #{sides}, expected #{expected_sides})"
      end

      dice
    end
  end
end
