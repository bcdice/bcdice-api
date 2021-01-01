# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'

require 'cgi'

require 'bcdice_api'

class APITest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BCDiceAPI::APP
  end

  def test_ping
    get '/'
    assert last_response.ok?
    assert_not_empty last_response.body
  end

  def test_version
    get '/v1/version'
    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json.key?('bcdice')
    assert json.key?('api')
  end

  def test_systems
    get '/v1/systems'
    json = JSON.parse(last_response.body)

    assert       last_response.ok?
    assert_false json['systems'].empty?
  end

  def test_names
    get '/v1/names'
    json = JSON.parse(last_response.body)

    assert       last_response.ok?
    assert_false json['names'].empty?
    dad = json['names'].find { |dicebot| dicebot['system'] == 'DungeonsAndDragons' }
    assert_equal dad['name'], 'ダンジョンズ＆ドラゴンズ'
    assert_equal dad['sort_key'], 'たんしよんすあんととらこんす'
  end

  def test_systeminfo
    get '/v1/systeminfo?system=DiceBot'
    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json['systeminfo']
    assert_equal json['systeminfo']['gameType'], 'DiceBot'
    assert_false json['systeminfo']['name'].empty?
    assert_instance_of Array, json['systeminfo']['prefixs']

    pend 'DiceBot::HELP_MESSAGE will be supported in BCDice v3'
    assert_false json['systeminfo']['info'].empty?
    assert_false json['systeminfo']['sortKey'].empty?
  end

  def test_diceroll
    get '/v1/diceroll?system=DiceBot&command=1d100<=70'

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json['ok']
    assert json['result']
    assert json['dices']
    assert_false json['secret']
  end

  def test_extratable
    get '/v1/diceroll?system=KanColle&command=WPFA'

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json['ok']
    assert json['result']
    assert json['dices']
    assert_false json['secret']
  end

  def test_detailed
    get '/v1/diceroll?system=Cthulhu7th&command=CC1'

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json['ok']
    assert_not_empty(json['detailed_rands'].select { |r| r['kind'] == 'tens_d10' })
  end

  def test_unexpected_dicebot
    get '/v1/diceroll?system=Hoge&command=1d100<=70'

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported dicebot'
  end

  def test_no_dicebot
    get '/v1/diceroll?command=1d100<=70'

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported dicebot'
  end

  def test_unexpected_command
    get '/v1/diceroll?system=DiceBot&command=a'

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported command'
  end

  def test_no_command
    get '/v1/diceroll?system=DiceBot'

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported command'
  end

  def test_no_params
    get '/v1/diceroll'

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported dicebot'
  end

  def test_blank_system
    get '/v1/diceroll?system='

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported dicebot'
  end

  def test_blank_command
    get '/v1/diceroll?system=DiceBot&command='

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported command'
  end

  def test_blank_both
    get '/v1/diceroll?system=&command='

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json['ok']
    assert_equal json['reason'], 'unsupported dicebot'
  end

  def test_not_found
    get '/hogehoge'
    json = JSON.parse(last_response.body)

    assert       last_response.not_found?
    assert_false json['ok']
    assert_equal json['reason'], 'not found'
  end
end
