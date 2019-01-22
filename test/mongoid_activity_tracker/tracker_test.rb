require 'test_helper'

describe MongoidActivityTracker::Tracker do
  subject { TestTracker.new }

  let(:actor) { TestActor.new }
  let(:sub) { TestSubject.new }

  describe 'associations' do
    it { subject.must_respond_to :actor }
  end

  describe 'fields' do
    it { subject.must_respond_to :action }
    it { subject.must_respond_to :actor_cache }
    it { subject.actor_cache.must_be_kind_of Hash }
  end

  describe '.track' do
    let(:result) { TestTracker.track(actor, :create, subject: sub) }

    it { result.must_be_kind_of TestTracker }
    it { result.actor.must_equal actor }
    it { result.actor_cache.must_equal(to_s: actor.to_s) }
    it { result.action.must_equal :create }
    it { result.subject.must_equal sub }
  end

  describe '.tracks' do
    it { subject.must_respond_to :subject }
    it { subject.must_respond_to :subject_cache }
    it { subject.subject_cache.must_be_kind_of Hash }
    it { subject.must_respond_to :subject_cache_methods }
    it { subject.subject_cache_methods.must_equal %i[to_s] }
    it { subject.subject_cache_object.must_respond_to :to_s }

    describe TestSubject do
      let(:tsubject) { TestSubject.new }

      before do
        subject.subject = tsubject
        subject.run_callbacks(:save)
      end

      it { subject.subject_cache.fetch(:to_s).must_equal tsubject.to_s }
    end
  end

  describe ':created_at' do
    it { subject.must_respond_to :created_at }
    it { subject.created_at.must_be_kind_of Time }
  end

  describe ':actor_cache' do
    before do
      subject.actor = actor
      subject.run_callbacks(:save)
    end

    it { subject.actor_cache.fetch(:to_s).must_equal actor.to_s }

    describe ':to_s' do
      before do
        subject.actor_cache[:to_s] = 'foo-bar'
        subject.run_callbacks(:save)
      end

      it { subject.actor_cache.fetch(:to_s).must_equal 'foo-bar' }
    end

    describe '#actor_cache_methods' do
      before do
        subject.actor_cache_methods = %i[class]
        subject.run_callbacks(:save)
      end

      it { subject.actor_cache.fetch(:class).must_equal TestActor }
    end
  end

  describe ':actor_cache_object' do
    it { subject.actor_cache_object.must_be_kind_of OpenStruct }
    it { subject.actor_cache_object.must_respond_to :to_s }
  end
end
