# frozen_string_literal: true

$LOAD_PATH.unshift __dir__
$LOAD_PATH.unshift File.join(__dir__, 'bcdice', 'src')
$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'bcdice_api'

run BCDiceAPI::App
