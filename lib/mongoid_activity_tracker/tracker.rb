require 'mongoid'

module MongoidActivityTracker
  module Tracker
      

    def self.included base
      base.class_eval do
        include Mongoid::Document
        
        belongs_to :actor, polymorphic: true
        
        field :actor_cache, type: Hash, default: {}
      end

      base.extend ClassMethods
    end

    module ClassMethods
    end

  end
end