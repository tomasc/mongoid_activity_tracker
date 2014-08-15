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
MongoidActivityTracker::TrackActivity.with(MyTracker, actor).track(subject: my_tracked_object)
```

## Contributing

1. Fork it ( https://github.com/tomasc/mongoid_activity_tracker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
