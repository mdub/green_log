# GreenLog

![](https://github.com/greensync/green_log/workflows/CI/badge.svg)

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

## Design approach

GreenLog:

- [avoids global state](doc/adr/0002-avoid-global-configuration.md)
- explicitly [decouples log entry generation and handling](doc/adr/0003-decouple-generation-and-handling.md)
- uses "[handler stacking](doc/adr/0004-use-stacked-handlers-to-solve-many-problems.md)" (similar to Rack middleware) to enable flexible log management

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/greensync/green_log.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
