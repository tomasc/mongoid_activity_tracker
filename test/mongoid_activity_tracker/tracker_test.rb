require 'test_helper'

require_relative '../../lib/mongoid_activity_tracker/tracker'

# ---------------------------------------------------------------------

class TestTrackerTwo
  include MongoidActivityTracker::Tracker
  tracks :subject
end

# ---------------------------------------------------------------------
      
module MongoidActivityTracker
  describe Tracker do

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

    # ---------------------------------------------------------------------

    describe '.tracks' do
      let(:tracker_two) { TestTrackerTwo.new }
      it 'adds the belongs_to :subject relation' do
        tracker_two.must_respond_to :subject
      end
      it 'adds the :subject_cache field' do
        tracker_two.must_respond_to :subject_cache
        tracker_two.subject_cache.must_be_kind_of Hash
      end
      it 'defines the :subject_cache_methods accessor' do
        tracker_two.must_respond_to :subject_cache_methods
      end
      it 'sets :to_s as a default for the :subject_cache_methods' do
        tracker_two.subject_cache_methods.must_equal %i(to_s)
      end
      it 'adds the :subject_cache_object wrapper' do
        tracker_two.subject_cache_object.must_respond_to :to_s
      end
      it 'sets the cache before :save' do
        test_subject = TestSubject.new
        tracker_two.subject = test_subject
        tracker_two.run_callbacks(:save)
        tracker_two.subject_cache.fetch(:to_s).must_equal test_subject.to_s
      end
    end
    
    # ---------------------------------------------------------------------
    
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