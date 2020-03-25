# frozen_string_literal: true
require 'yaml'

module BCDiceAPI
  def self.load_admin_info
    config = {
      name: '',
      url: '',
      email: ''
    }

    path = File.expand_path('../config/admin.yaml', __dir__)
    if File.exist?(path)
      yaml = YAML.load_file(path)
      config = {
        name: yaml['name'].to_s,
        url: yaml['url'].to_s,
        email: yaml['email'].to_s
      }
    end

    config[:name] = ENV['BCDICEAPI_ADMIN_NAME'] if ENV['BCDICEAPI_ADMIN_NAME']
    config[:url] = ENV['BCDICEAPI_ADMIN_URL'] if ENV['BCDICEAPI_ADMIN_URL']
    config[:email] = ENV['BCDICEAPI_ADMIN_EMAIL'] if ENV['BCDICEAPI_ADMIN_EMAIL']

    config
  end

  ADMIN = load_admin_info
end
