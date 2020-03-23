# frozen_string_literal: true
require 'yaml'

module BCDiceAPI
  def self.load_config
    path = File.expand_path('../config/admin.yaml', __dir__)
    config = if File.exist?(path)
        yaml = YAML.load_file(path)
        {
          name: yaml['admin_name'],
          address: yaml['admin_address']
        }
      else
        {
          name: nil,
          address: nil
        }
      end

    config.merge(
      {
        name: ENV['BCDiceAPI_ADMIN_NAME'],
        address: ENV['BCDiceAPI_ADMIN_ADDRESS']
      }.compact
    )
  end

  ADMIN = load_config
end
