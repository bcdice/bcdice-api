# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'

require 'cgi'

require 'bcdice_api'

class V2APITest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BCDiceAPI::APP
  end

  def test_version
    get '/v2/version'
    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal '*', last_response.headers['Access-Control-Allow-Origin']
    assert json.key?('bcdice')
    assert json.key?('api')
  end

  def test_game_system_list
    get '/v2/game_system'
    json = JSON.parse(last_response.body)

    assert       last_response.ok?
    assert_false json['game_system'].empty?
    assert_instance_of Array, json['game_system']

    first = json['game_system'].first
    assert first.key?('name')
    assert first.key?('id')
    assert first.key?('sort_key')
  end

  def test_game_system_info
    get '/v2/game_system/DiceBot'
    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json['ok']
    assert_equal json['id'], 'DiceBot'
    assert_instance_of String, json['name']
    assert_instance_of String, json['command_pattern']
    assert_instance_of String, json['sort_key']
    assert_instance_of String, json['help_message']
    assert_false json['name'].empty?
    assert_false json['command_pattern'].empty?
    assert_false json['sort_key'].empty?

    assert_false json['help_message'].empty?
  end

  def test_diceroll
    get '/v2/game_system/DiceBot/roll?command=1d100<=70'

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json['ok']
    assert json['text']
    assert_false json['secret']
    assert_boolean json['success']
    assert_boolean json['failure']
    assert_false json['critical']
    assert_false json['fumble']
    assert_instance_of Array, json['rands']
  end

  def test_diceroll_with_post
    post '/v2/game_system/DiceBot/roll', { command: '1d100<=70' }

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json['ok']
    assert json['text']
    assert_false json['secret']
    assert_boolean json['success']
    assert_boolean json['failure']
    assert_false json['critical']
    assert_false json['fumble']
    assert_instance_of Array, json['rands']
  end

  def test_detailed
    get '/v2/game_system/Cthulhu7th/roll?command=CC1'

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json['ok']
    assert_not_empty(json['rands'].select { |r| r['kind'] == 'tens_d10' })
  end

  def test_unexpected_game_system
    get '/v2/game_system/Hoge/roll?command=1d100<=70'

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported game system'
  end

  def test_unexpected_command
    get '/v2/game_system/DiceBot/roll?command=a'

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported command'
  end

  def test_no_command
    get '/v2/game_system/DiceBot/roll'

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported command'
  end

  def test_blank_command
    get '/v2/game_system/DiceBot/roll?command='

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported command'
  end

  def test_original_table
    table_text = <<~TABLE
      飲み物表
      1D6
      1:水
      2:緑茶
      3:麦茶
      4:コーラ
      5:オレンジジュース
      6:選ばれし者の知的飲料
    TABLE

    post '/v2/original_table', { table: table_text }

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_true json['ok']
    assert_instance_of String, json['text']
    assert_true json['text'].start_with?('飲み物表(')
    assert_instance_of Array, json['rands']
  end
end
