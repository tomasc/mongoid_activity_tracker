require 'mongoid'
require 'ostruct'

module MongoidActivityTracker
  module Tracker
    attr_accessor :actor_cache_methods

    module ClassMethods
      def track(actor, action, options = {})
        create({ action: action, actor: actor }.merge(options))
      end

      # ---------------------------------------------------------------------

      def tracks(relation_name, cache_methods: %i(to_s))
        field_name = [relation_name, 'cache'].join('_')
        accessor_name = [relation_name, 'cache_methods'].join('_')
        instance_variable_name = ['@', accessor_name].join

        field field_name, type: Hash, default: {}

        belongs_to relation_name, polymorphic: true, optional: true

        attr_accessor accessor_name

        define_method accessor_name do
          instance_variable_set(instance_variable_name, cache_methods) unless instance_variable_get(instance_variable_name)
          instance_variable_get(instance_variable_name)
        end

        define_method [relation_name, 'cache_object'].join('_') do
          OpenStruct.new(send(field_name))
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

    def set_cache(relation_name)
      accessor_name = [relation_name, 'cache_methods'].join('_')
      field_name = [relation_name, 'cache'].join('_')

      return unless send(accessor_name).present?
      return unless send(relation_name).present?

      send(accessor_name).each do |m|
        next if send(field_name)[m].present?
        send(field_name)[m] = send(relation_name).send(m) if send(relation_name).respond_to?(m)
      end
    end
  end
end
