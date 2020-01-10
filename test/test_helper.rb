require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_bot'
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  FactoryBot.define do
    factory :user do
      email { "usertest@digitalimpactalliance.org" }
      password { "password"} 
      password_confirmation { "password" }
      confirmed_at { Date.today }
      role { :user }
    end
  end
end
