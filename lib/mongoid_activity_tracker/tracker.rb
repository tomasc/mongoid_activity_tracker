require 'mongoid'
require 'ostruct'

module MongoidActivityTracker
  module Tracker

    attr_accessor :actor_cache_methods

    def self.included base
      base.class_eval do
        include Mongoid::Document

        belongs_to :actor, polymorphic: true

        field :action, type: String
        field :actor_cache, type: Hash, default: {}

        validates :actor, presence: true
        validates :action, presence: true

        before_save -> { set_cache(:actor) }
      end

      base.extend ClassMethods
    end

    def created_at
      self.id.generation_time.in_time_zone(Time.zone)
    end

    def actor_cache_methods
      @actor_cache_methods ||= %i(to_s)
    end

    def actor_cache_object
      OpenStruct.new(actor_cache)
    end

    private # =============================================================

    def set_cache name
      return unless self.send("#{name}_cache_methods").present?
      return unless self.send(name).present?

      self.send("#{name}_cache_methods").each do |m|
        next if self.send("#{name}_cache")[m].present?
        self.send("#{name}_cache")[m] = self.send(name).send(m) if self.send(name).respond_to?(m)
      end
    end

  end
end
