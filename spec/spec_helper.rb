# Encoding: UTF-8

require 'chef'
require 'chefspec'
require 'chefspec/berkshelf'
require 'tempfile'
require 'simplecov'
require 'simplecov-console'
require 'coveralls'
require 'tmpdir'
require 'fileutils'

RSpec.configure do |c|
  c.color = true
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console
]
SimpleCov.minimum_coverage(100)
SimpleCov.start

at_exit { ChefSpec::Coverage.report! }
