require 'test_helper'

require_relative '../../lib/mongoid_activity_tracker/track_activity'
require_relative '../../lib/mongoid_activity_tracker/tracker'

class TestTracker
  include Mongoid::Document
  include MongoidActivityTracker::Tracker
end

# ---------------------------------------------------------------------
  
module MongoidActivityTracker
  describe Tracker do
  end
end