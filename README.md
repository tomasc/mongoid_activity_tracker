# Mongoid Activity Tracker

[![Build Status](https://travis-ci.org/tomasc/mongoid_activity_tracker.svg)](https://travis-ci.org/tomasc/mongoid_activity_tracker) [![Gem Version](https://badge.fury.io/rb/mongoid_activity_tracker.svg)](http://badge.fury.io/rb/mongoid_activity_tracker) [![Coverage Status](https://img.shields.io/coveralls/tomasc/mongoid_activity_tracker.svg)](https://coveralls.io/r/tomasc/mongoid_activity_tracker)

Module to help with tracking activity in your application.

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
res = MyTracker.track(current_user, :create)

res.actor # returns the current_user
res.actor_cache # => { to_s: … }
res.actor_cache_object.to_s # the 'actor_cache_object' wraps the actor_cache hash into an OpenStruct
res.action # => :create
```

## Configuration

Along the action, it is possible to track any number of related documents.

First, configure the tracker class using the `.tracks` macro:

```Ruby
class MyTracker
  include MongoidActivityTracker::Tracker
  tracks :subject
end
```

Then, specify the subject when tracking the activity:

```Ruby
res = MyTracker.track(current_user, :create, subject: my_subject)

res.subject # => my_subject
res.subject_cache # => { to_s: … }
res.subject_cache_object.to_s # …
```

By default, the `:cache_methods` parameter is set to store the result of `:to_s` method. This is valuable for example when displaying activity overview (no need for additional query for the related document), or should the related document no longer exist. The list of methods to be cached can be customised as follows:

```Ruby
class MyTracker
  include MongoidActivityTracker::Tracker
  tracks :actor, cache_methods: [:to_s, :first_name, :last_name]
  tracks :subject, cache_methods: [:to_s, :some_other_method]
end
```

The tracker class can be also subclassed:

```Ruby
class MyTrackerWithTarget < MyTracker
  tracks :target
end
```

## Contributing

1. Fork it ( https://github.com/tomasc/mongoid_activity_tracker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
