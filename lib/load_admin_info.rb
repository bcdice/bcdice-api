# frozen_string_literal: true
require 'yaml'

module BCDiceAPI
  def self.load_admin_info
    config = {}

    path = File.expand_path('../config/admin.yaml', __dir__)
    if File.exist?(path)
      yaml = YAML.load_file(path)
      config = {
        name: yaml['name'],
        url: yaml['url'],
        email: yaml['email']
      }
    end

    config[:name] = ENV['BCDiceAPI_ADMIN_NAME'] if ENV['BCDiceAPI_ADMIN_NAME']
    config[:url] = ENV['BCDiceAPI_ADMIN_URL'] if ENV['BCDiceAPI_ADMIN_URL']
    config[:email] = ENV['BCDiceAPI_ADMIN_EMAIL'] if ENV['BCDiceAPI_ADMIN_EMAIL']

    config
  end

  ADMIN = load_admin_info
end
