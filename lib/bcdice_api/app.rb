# frozen_string_literal: true

require_relative 'controller/root'
require_relative 'controller/v2'

module BCDiceAPI
  APP = Rack::URLMap.new(
    {
      '/' => Controller::Root,
      '/v2' => Controller::V2
    }
  )
end
