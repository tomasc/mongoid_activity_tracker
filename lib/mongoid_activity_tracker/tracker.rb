require 'mongoid'
require 'ostruct'

module MongoidActivityTracker
  module Tracker
    attr_accessor :actor_cache_methods

    module ClassMethods
      def track(_actor, _action, options = {})
        create({ action: _action, actor: _actor }.merge(options))
      end

      # ---------------------------------------------------------------------

      def tracks(relation_name, cache_methods: %i(to_s))
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

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include Mongoid::Document

        field :action, type: Symbol

        tracks :actor

        validates :actor, presence: true
        validates :action, presence: true
      end
    end

    # =====================================================================

    def created_at
      id.generation_time.in_time_zone(Time.zone)
    end

    private # =============================================================

    def set_cache(name)
      return unless send("#{name}_cache_methods").present?
      return unless send(name).present?

      send("#{name}_cache_methods").each do |m|
        next if send("#{name}_cache")[m].present?
        send("#{name}_cache")[m] = send(name).send(m) if send(name).respond_to?(m)
      end
    end
  end
end
