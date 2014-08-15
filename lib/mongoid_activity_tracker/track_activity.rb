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

    def track action, options={}
      @tracker_class.create(
        { action: action, actor: @actor}.merge(options)
      )
    end

  end
end