# frozen_string_literal: true

require 'yaml'

module BCDiceAPI
  class << self
    private

    # @return [Hash]
    def load_admin_info
      config = {
        name: '',
        url: '',
        email: ''
      }

      config.merge! load_from_yaml
      config.merge! load_from_env

      config
    end

    # @return [Hash]
    def load_from_yaml
      path = File.expand_path('../../config/admin.yaml', __dir__)
      return {} unless File.exist?(path)

      yaml = YAML.load_file(path)
      {
        name: yaml['name'].to_s,
        url: yaml['url'].to_s,
        email: yaml['email'].to_s
      }
    end

    # @return [Hash]
    def load_from_env
      config = {}
      config[:name] = ENV['BCDICE_API_ADMIN_NAME'] if ENV['BCDICE_API_ADMIN_NAME']
      config[:url] = ENV['BCDICE_API_ADMIN_URL'] if ENV['BCDICE_API_ADMIN_URL']
      config[:email] = ENV['BCDICE_API_ADMIN_EMAIL'] if ENV['BCDICE_API_ADMIN_EMAIL']

      config
    end
  end

  ADMIN = load_admin_info
end
