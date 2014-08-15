require 'test_helper'

require_relative '../../lib/mongoid_activity_tracker/tracker'
  
module MongoidActivityTracker
  describe 'Tracker' do

    let(:actor) { TestActor.new }
    subject { TestTracker.new }

    describe 'associations' do
      it 'belongs to :actor' do
        subject.must_respond_to :actor
      end
    end

    describe 'fields' do
      it 'has :action' do
        subject.must_respond_to :action
      end
      it 'has :actor_cache' do
        subject.must_respond_to :actor_cache
        subject.actor_cache.must_be_kind_of Hash
      end
    end

    describe ':created_at' do
      it 'infers time from BSON id' do
        subject.must_respond_to :created_at
        subject.created_at.must_be_kind_of Time
      end
    end

    describe ':actor_cache' do
      before do
        subject.actor = actor
      end
      it 'sets :actor_cache on save' do
        subject.run_callbacks(:save)
        subject.actor_cache.fetch(:to_s).must_equal actor.to_s
      end
      it 'allows preset cache manually' do
        subject.actor_cache[:to_s] = 'foo-bar'
        subject.run_callbacks(:save)
        subject.actor_cache.fetch(:to_s).must_equal 'foo-bar'
      end
      it 'allows to override the default cache methods' do
        subject.actor_cache_methods = %i(class)
        subject.run_callbacks(:save)
        subject.actor_cache.fetch(:class).must_equal TestActor
      end
    end

    describe ':actor_cache_object' do
      it 'wraps the :actor_cache with a Struct' do
        subject.actor_cache_object.must_be_kind_of OpenStruct
      end
      it 'converts keys to methods' do
        subject.actor_cache_object.must_respond_to :to_s
      end
    end

  end
end