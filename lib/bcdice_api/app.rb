# frozen_string_literal: true

require_relative 'controller/root'
require_relative 'controller/tester'
require_relative 'controller/v1'
require_relative 'controller/v2'

module BCDiceAPI
  APP = Rack::URLMap.new(
    {
      '/' => Controller::Root,
      '/tester' => Controller::Tester,
      '/v1' => Controller::V1,
      '/v2' => Controller::V2
    }
  )
end
