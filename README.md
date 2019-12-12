# GreenLog

GreenLog is a logging library for Ruby applications.  It:

- focuses on [structured logging](https://www.thoughtworks.com/radar/techniques/structured-logging) - treating log entries as data
- is optimised for use in modern "cloud-native" applications
- uses patterns based on Rack middleware for log processing
- can be used in place of Ruby's stdlib `Logger`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'green_log'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install green_log

## Usage

```ruby
logger = GreenLog::Logger.new(
  GreenLog::JsonWriter.new(STDOUT)
)

logger.info("Stuff happened")
logger.warn("Too many requests", user: user_id)
```

TODO: Write usage instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/greensync/green_log.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
