# frozen_string_literal: true
ENV["RACK_ENV"] = "test"
require "test/unit"
require "rack/test"

require "cgi"

require File.expand_path "../server.rb", __dir__

class API_Test < Test::Unit::TestCase
  include Rack::Test::Methods

  def app()
    Sinatra::Application
  end

  def test_ping
    get "/"
    assert last_response.ok?
    assert_not_empty last_response.body
  end

  def test_version
    get "/v1/version"
    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json.key?("bcdice")
    assert json.key?("api")
  end

  def test_systems
    get "/v1/systems"
    json = JSON.parse(last_response.body)

    assert       last_response.ok?
    assert_false json["systems"].empty?
  end

  def test_names
    get "/v1/names"
    json = JSON.parse(last_response.body)

    assert       last_response.ok?
    assert_false json["names"].empty?
    dad = json["names"].find {|dicebot| dicebot["system"] == "DungeonsAndDoragons"}
    assert_equal dad["name"], "ダンジョンズ＆ドラゴンズ"
  end

  def test_systeminfo
    get "/v1/systeminfo?system=DiceBot"
    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json["systeminfo"]
    assert_equal json["systeminfo"]["gameType"], "DiceBot"
    assert_false json["systeminfo"]["name"].empty?
    assert       json["systeminfo"]["prefixs"]
    assert_false json["systeminfo"]["info"].empty?
  end

  def test_diceroll
    get "/v1/diceroll?system=DiceBot&command=1d100<=70"

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json["ok"]
    assert json["result"]
    assert json["dices"]
    assert_false json["secret"]
  end

  def test_extratable
    get "/v1/diceroll?system=KanColle&command=WPFA"

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json["ok"]
    assert json["result"]
    assert json["dices"]
    assert_false json["secret"]
  end

  data("単純な四則演算", "C(1+2-3*4/5)")
  data("括弧を含む四則演算", "C(1+(2-3*4/(5/6))-7)")
  data("計算コマンドの後に文字列が存在する場合（空白あり）", "C(10+5) mokekeke")
  def test_calc(command)
    get "/v1/diceroll?system=DiceBot&command=#{CGI.escape(command)}"

    json = JSON.parse(last_response.body)

    assert last_response.ok?
    assert json["ok"]
    assert json["result"].start_with?(": 計算結果 ＞ ")
    assert_equal json["dices"], []
    assert_false json["secret"]
  end

  data("Cの後に数字のみが続く場合", "C42")
  data("括弧が閉じられていない場合", "C(1+2")
  data("空白で始まる場合", " C(1+2)")
  data("計算コマンドの後に文字列が存在する場合（空白なし）", "C(10+5)mokekeke")
  def test_pseudo_calc(command)
    get "/v1/diceroll?system=DiceBot&command=#{CGI.escape(command)}"

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported command"
  end

  def test_unexpected_dicebot
    get "/v1/diceroll?system=Hoge&command=1d100<=70"

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported dicebot"
  end

  def test_no_dicebot
    get "/v1/diceroll?command=1d100<=70"

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported dicebot"
  end

  def test_unexpected_command
    get "/v1/diceroll?system=DiceBot&command=a"

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported command"
  end

  def test_no_command
    get "/v1/diceroll?system=DiceBot"

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported command"
  end

  def test_no_params
    get "/v1/diceroll"

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported dicebot"
  end

  def test_blank_system
    get "/v1/diceroll?system="

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported dicebot"
  end

  def test_blank_command
    get "/v1/diceroll?system=DiceBot&command="

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported command"
  end

  def test_blank_both
    get "/v1/diceroll?system=&command="

    json = JSON.parse(last_response.body)

    assert last_response.bad_request?
    assert_false json["ok"]
    assert_equal json["reason"], "unsupported dicebot"
  end

  def test_onset_list
    get "/v1/onset?list=1"

    list = last_response.body.split("\n")

    assert last_response.ok?
    assert_include list, "Amadeus"
  end

  def test_onset_diceroll
    get "/v1/onset?sys=Cthulhu&text=1d20"

    assert last_response.ok?
    assert last_response.body.start_with?("onset: (1D20)")
  end

  def test_onset_unexpected_dicebot
    get "/v1/onset?sys=AwesomeDicebot&text=1d20"

    assert last_response.ok?
    assert_equal last_response.body, "error"
  end

  def test_onset_unexpected_command
    get "/v1/onset?sys=DiceBot&text=a"

    assert last_response.ok?
    assert_equal last_response.body, "error"
  end

  def test_not_found
    get "/hogehoge"
    json = JSON.parse(last_response.body)

    assert       last_response.not_found?
    assert_false json["ok"]
    assert_equal json["reason"], "not found"
  end
end
