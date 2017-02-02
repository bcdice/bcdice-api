require 'bundler'
Bundler.require

require './server'
run Sinatra::Application
