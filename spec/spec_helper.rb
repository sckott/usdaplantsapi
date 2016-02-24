ENV['RACK_ENV'] = 'test'
require_relative '../api'
Bundler.require(:test)
require 'nulldb_rspec'

include NullDB::RSpec::NullifiedDatabase

module TestHelperMixin
  include Rack::Test::Methods
  def app
    API
  end
end

RSpec.configure do |config|
  config.include TestHelperMixin
end

class Array
  def limit(_)
    Array.new(3,1)
  end
end
