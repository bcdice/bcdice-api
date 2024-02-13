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

  def test_not_found
    get '/hogehoge'
    json = JSON.parse(last_response.body)

    assert       last_response.not_found?
    assert_false json['ok']
    assert_equal json['reason'], 'not found'
  end
end
