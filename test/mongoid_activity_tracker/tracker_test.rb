require 'test_helper'

module MongoidActivityTracker
  describe Tracker do

    let(:actor) { TestActor.new }
    let(:sub) { TestSubject.new }
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
    
    describe '.track' do
      before do
        @result = TestTracker.track(actor, :create, subject: sub)
      end
      it 'returns new object' do
        @result.must_be_kind_of TestTracker
      end
      it 'always sets the :actor' do
        @result.actor.must_equal actor
      end
      it 'sets the :actor_cache with :to_s by default' do
        @result.actor_cache.must_equal({ to_s: actor.to_s })
      end
      it 'sets the :action' do
        @result.action.must_equal :create
      end
      it 'sets any other attributes' do
        @result.subject.must_equal sub
      end
    end

    # ---------------------------------------------------------------------

    describe '.tracks' do
      it 'adds the belongs_to :subject relation' do
        subject.must_respond_to :subject
      end
      it 'adds the :subject_cache field' do
        subject.must_respond_to :subject_cache
        subject.subject_cache.must_be_kind_of Hash
      end
      it 'defines the :subject_cache_methods accessor' do
        subject.must_respond_to :subject_cache_methods
      end
      it 'sets :to_s as a default for the :subject_cache_methods' do
        subject.subject_cache_methods.must_equal %i(to_s)
      end
      it 'adds the :subject_cache_object wrapper' do
        subject.subject_cache_object.must_respond_to :to_s
      end
      it 'sets the cache before :save' do
        test_subject = TestSubject.new
        subject.subject = test_subject
        subject.run_callbacks(:save)
        subject.subject_cache.fetch(:to_s).must_equal test_subject.to_s
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