# frozen_string_literal: true
require "rake/testtask"
require 'rubocop/rake_task'

desc "Run test-unit based test"
Rake::TestTask.new do |t|
  # To run test for only one file (or file path pattern)
  #  $ bundle exec rake test TEST=test/test_specified_path.rb
  t.libs += ["lib", "bcdice/src"]
  t.test_files = Dir["test/test_*.rb"]
  t.verbose = true
end

RuboCop::RakeTask.new
