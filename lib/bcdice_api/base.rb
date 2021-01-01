# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'exception'

module BCDiceAPI
  class Base < Sinatra::Base
    class << self
      attr_accessor :test_rands
    end

    configure :production do
      set :dump_errors, false
    end

    configure :development do
      register Sinatra::Reloader
    end

    before do
      response.headers['Access-Control-Allow-Origin'] = '*'
    end
  end
end
