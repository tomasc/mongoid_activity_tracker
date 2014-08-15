require 'test_helper'

require_relative '../../lib/mongoid_activity_tracker/track_activity'

module MongoidActivityTracker
  describe TrackActivity do
    let(:actor) { TestActor.new }
    subject { TrackActivity.with(TestTracker, actor) }

    describe '.call' do
      before do
        @tracker = subject.track
      end
      it 'returns the tracker instance' do
        @tracker.must_be_kind_of TestTracker
      end
      it 'always sets the :actor' do
        @tracker.actor.must_equal actor
      end
    end

  end
end