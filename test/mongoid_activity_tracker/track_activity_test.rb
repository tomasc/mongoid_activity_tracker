require 'test_helper'

require_relative '../../lib/mongoid_activity_tracker/track_activity'

module MongoidActivityTracker
  describe TrackActivity do
    let(:actor) { TestActor.new }
    subject { TrackActivity.with(TestTrackerTwo, actor) }
    let(:sub) { TestSubject.new }

    describe '.call' do
      before do
        @tracker = subject.track('create', subject: sub)
      end
      it 'returns the tracker instance' do
        @tracker.must_be_kind_of TestTrackerTwo
      end
      it 'always sets the :actor' do
        @tracker.actor.must_equal actor
      end
      it 'sets the :actor_cache with :to_s by default' do
        @tracker.actor_cache.must_equal({ to_s: actor.to_s })
      end
      it 'always sets the :action' do
        @tracker.action.must_equal 'create'
      end
      it 'sets any other attributes' do
        @tracker.subject.must_equal sub
      end
    end

  end
end