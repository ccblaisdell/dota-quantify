ENV["RAILS_ENV"] ||= "test"
require 'simplecov'
SimpleCov.start
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  setup do
    I18n.locale = :en
    Mongoid.purge!
  end

  teardown do
    Mongoid.purge!
  end
end
