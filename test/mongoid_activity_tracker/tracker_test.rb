require 'test_helper'

require_relative '../../lib/mongoid_activity_tracker/tracker'
  
module MongoidActivityTracker
  describe 'Tracker' do

    subject { TestTracker.new }

    describe 'associations' do
      it 'belongs to :actor' do
        subject.must_respond_to :actor
      end
    end

    describe 'fields' do
      it 'has :actor_cache' do
        subject.must_respond_to :actor_cache
        subject.actor_cache.must_be_kind_of Hash
      end
    end

  end
end