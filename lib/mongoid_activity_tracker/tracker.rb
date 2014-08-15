require 'mongoid'
require 'ostruct'

module MongoidActivityTracker
  module Tracker

    attr_accessor :actor_cache_methods

    module ClassMethods
      def tracks relation_name, cache_methods: %i(to_s)
        belongs_to relation_name, polymorphic: true

        field "#{relation_name}_cache", type: Hash, default: {}

        attr_accessor "#{relation_name}_cache_methods"

        define_method "#{relation_name}_cache_methods" do
          instance_variable_set("@#{relation_name}_cache_methods", cache_methods) unless instance_variable_get("@#{relation_name}_cache_methods")
          instance_variable_get("@#{relation_name}_cache_methods")
        end

        define_method "#{relation_name}_cache_object" do
          OpenStruct.new(send("#{relation_name}_cache"))
        end

        before_save -> { set_cache(relation_name) }
      end
    end

    # ---------------------------------------------------------------------

    def self.included base
      base.extend ClassMethods
      base.class_eval do
        include Mongoid::Document

        field :action, type: String

        tracks :actor

        validates :actor, presence: true
        validates :action, presence: true
      end

    end

    # =====================================================================

    def created_at
      self.id.generation_time.in_time_zone(Time.zone)
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
