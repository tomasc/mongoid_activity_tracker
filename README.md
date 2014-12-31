# Mongoid Activity Tracker

[![Build Status](https://travis-ci.org/tomasc/mongoid_activity_tracker.svg)](https://travis-ci.org/tomasc/mongoid_activity_tracker) [![Gem Version](https://badge.fury.io/rb/mongoid_activity_tracker.svg)](http://badge.fury.io/rb/mongoid_activity_tracker) [![Coverage Status](https://img.shields.io/coveralls/tomasc/mongoid_activity_tracker.svg)](https://coveralls.io/r/tomasc/mongoid_activity_tracker)

Module and a service class to help with tracking activity in your application.

## Installation

Add this line to your application's Gemfile:

```Ruby
gem 'mongoid_activity_tracker'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install mongoid_activity_tracker
```

## Usage

Setup a class that will record the activity:

```Ruby
class MyTracker
  include MongoidActivityTracker::Tracker
end
```

Track the activity:

```Ruby
my_tracker = MongoidActivityTracker::TrackActivity.with(MyTracker, current_user)

res = my_tracker.track('create')

res.actor # returns the current_user
res.actor_cache # => { to_s: … }
res.actor_cache_object.to_s # the 'actor_cache_object' wraps the actor_cache hash into an OpenStruct
res.action # => 'create'
```

## Configuration

Along the action, it is possible to track any number of related documents.

First, configure your tracker class using the `.tracks` macros:

```Ruby
class MyTracker
  include MongoidActivityTracker::Tracker
  tracks :subject, cache_methods: [:to_s, :id]
end
```

Then, specify your subject when tracking the activity:

```Ruby
my_tracker = MongoidActivityTracker::TrackActivity.with(MyTracker, current_user)

res = my_tracker.track('create', subject: my_subject)

res.subject # returns my_subject
res.subject_cache # => { to_s: …, id: … }
res.subject_cache_object.to_s # …
```

By default, the `:cache_methods` parameters is set to track [:to_s].

You can subclass your tracker  class for specific cases:

```Ruby
class MyTargetTracker < MyTracker
  tracks :target
end
```

## Contributing

1. Fork it ( https://github.com/tomasc/mongoid_activity_tracker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
