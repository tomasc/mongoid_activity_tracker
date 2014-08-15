module MongoidActivityTracker
  class TrackActivity

    def self.with *args
      new(*args)
    end

    # ---------------------------------------------------------------------
    
    def initialize tracker_class, actor
      @tracker_class = tracker_class
      @actor = actor
    end

    def track
      @tracker_class.create(
        actor: @actor
      )
    end

  end
end