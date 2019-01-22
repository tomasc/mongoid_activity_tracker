# CHANGELOG

## 0.2.5

* tracker is valid even if `:actor` is not present, but `:to_s` is stored in `#actor_cache`
  * renders past activity valid event if the actor model has been removed from the database

## 0.2.4

* Mongoid 7 compatibility
