require 'bundler/setup'
require 'database_cleaner'
require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

require 'mongoid'
require 'mongoid_activity_tracker'

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO
Mongoid.configure do |config|
  config.connect_to('mongoid_activity_tracker_test')
end

DatabaseCleaner.orm = :mongoid
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before(:each) { DatabaseCleaner.clean }
end

# ---------------------------------------------------------------------

class TestTracker
  include MongoidActivityTracker::Tracker
  tracks :subject
end

class TestActor
  include Mongoid::Document
end

class TestSubject
  include Mongoid::Document
end
