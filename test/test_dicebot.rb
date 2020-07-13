# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'

require 'cgi'

require 'test/DiceBotTestData'

require 'bcdice_api'

class DicebotTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BCDiceAPI::App
  end

  class << self
    def format_expected(expected)
      expected = expected.sub('###secret dice###', '')
      part = expected.partition(':')

      if expected.empty? || expected.start_with?('ダイス残り：')
        nil
      elsif part[2].empty?
        expected
      else
        part[1] + part[2]
      end
    end

    def expected_secret(expected)
      if expected.empty? || expected.start_with?('ダイス残り：')
        nil
      else
        expected.end_with?('###secret dice###')
      end
    end
  end

  data do
    data_set = {}
    files = Dir.glob('bcdice/src/test/data/*.txt')

    files.each do |filename|
      class_name = File.basename(filename, '.txt')
      next if class_name[0] == '_'

      class_name = 'DiceBot' if ['UpperDice'].include?(class_name)

      dicebot = begin
                  Object.const_get(class_name)
                rescue StandardError
                  DiceBot
                end

      sources = File.read(filename)
                    .gsub("\r\n", "\n")
                    .tr("\r", "\n")
                    .split("============================\n")
                    .map(&:chomp)

      sources.map.with_index(1) do |source, i|
        data = DiceBotTestData.parse(source, dicebot::ID, i)
        key = [class_name, data.index, data.input].join(':')

        next if data.input.join("\n").upcase.include?('OPEN DICE!')

        data_set[key] = {
          system: dicebot::ID,
          command: data.input.join("\n"),
          expected: DicebotTest.format_expected(data.output),
          secret: expected_secret(data.output),
          rands: data.rands
        }
      end
    end

    data_set
  end
  def test_diceroll(data)
    BCDiceAPI::App.test_rands = data[:rands]

    get '/v1/diceroll', system: data[:system], command: data[:command]

    json = JSON.parse(last_response.body)
    assert_equal data[:expected], json['result']
    assert_equal data[:secret], json['secret']
  end
end
