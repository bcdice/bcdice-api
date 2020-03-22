# frozen_string_literal: true
require 'yaml'

module BCDiceAPI
  path = File.expand_path('../config/admin.yaml', __dir__)
  if File.exist?(path)
    yaml = YAML.load_file(path)
  else
    yaml = {
      name: nil,
      address: nil
    }.freeze
  end

  ADMIN = {
    name: yaml['admin_name'],
    address: yaml['admin_address']
  }
end
