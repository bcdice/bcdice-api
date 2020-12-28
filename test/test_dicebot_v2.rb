# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'
require 'tomlrb'

require 'bcdice_api'

class V2DicebotTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BCDiceAPI::App
  end

  data do
    data_set = {}
    files = Dir.glob('bcdice/test/data/*.toml')

    files.each do |filename|
      filename_base = File.basename(filename, '.toml')
      data = Tomlrb.load_file(filename, symbolize_keys: true)

      data[:test].each.with_index(1) do |test_case, index|
        test_case[:filename] = filename
        test_case[:output] = nil if test_case[:output].empty? # TOMLではnilを表現できないので空文字で代用
        test_case[:secret] ||= false
        test_case[:success] ||= false
        test_case[:failure] ||= false
        test_case[:critical] ||= false
        test_case[:fumble] ||= false

        key = [filename_base, index, test_case[:input]].join(':')

        data_set[key] = test_case
      end
    end

    data_set
  end
  def test_diceroll(data)
    BCDiceAPI::V2::App.test_rands = data[:rands].map { |r| [r[:value], r[:sides]] }

    get "/v2/game_system/#{data[:game_system]}/roll", command: data[:input]

    json = JSON.parse(last_response.body)
    assert_equal data[:output], json['text']
    return unless data[:output]

    assert_equal data[:secret], json['secret']
    assert_equal data[:success], json['success']
    assert_equal data[:failure], json['failure']
    assert_equal data[:critical], json['critical']
    assert_equal data[:fumble], json['fumble']
  end
end
