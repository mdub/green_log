# GreenLog

![](https://github.com/greensync/green_log/workflows/CI/badge.svg)

GreenLog is a logging library for Ruby applications.  It:

- focuses on [structured logging](https://www.thoughtworks.com/radar/techniques/structured-logging) - treating log entries as data
- is optimised for use in modern "cloud-native" applications
- can be used in place of Ruby's stdlib `Logger`

## Design approach

GreenLog:

- [avoids global state](doc/adr/0002-avoid-global-configuration.md)
- explicitly [decouples log entry generation and handling](doc/adr/0003-decouple-generation-and-handling.md)
- uses [an approach similar to Rack middleware](doc/adr/0004-use-stacked-handlers-to-solve-many-problems.md) for flexible log processing
- uses [lock-free IO](doc/adr/0006-use-lock-free-io.md) for performance

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
logger = GreenLog::Logger.build(dest: STDOUT)

logger.info("Stuff happened")
logger.warn("Too many requests", user: user_id)
```

### Alternate output destination or format

By default GreenLog logs with a human-readable format; specify an alternate `format`
class if you want a different serialisation format. It comes bundled with a JSON writer, e.g.

```ruby
logger = GreenLog::Logger.build(format: GreenLog::JsonWriter)
```

Logs go to STDOUT by default; specify `dest` to override, e.g.

```ruby
logger = GreenLog::Logger.build(dest: STDERR)
```

### Filtering by log severity

By default all log entries will result in output. You can add a severity-threshold to avoid emitting debug-level log messages, e.g.

```ruby
logger = GreenLog::Logger.build(severity_threshold: :INFO)
# OR
logger = GreenLog::Logger.build.with_severity_threshold(:INFO)

log.debug("Whatever") # ignored
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/greensync/green_log.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
