require 'mongoid'

module MongoidActivityTracker
  module Tracker
      

    def self.included base
      base.class_eval do
        include Mongoid::Document
        
        belongs_to :actor, polymorphic: true
        
        field :action, type: String
        field :actor_cache, type: Hash, default: {}

        validates :actor, presence: true
        validates :action, presence: true
      end

      base.extend ClassMethods
    end

    module ClassMethods
    end

  end
end