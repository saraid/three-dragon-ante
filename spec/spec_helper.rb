require "bundler/setup"
require "three-dragon-ante"

require_relative './fixture_helper'
Dir.each_child(File.join(__dir__, 'factories')) do |factory|
  next unless factory.end_with?('.rb')
  require_relative "./factories/#{factory}"
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
