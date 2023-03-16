# GreenLog

[![Gem Version](https://badge.fury.io/rb/green_log.svg)](http://badge.fury.io/rb/green_log)
[![Build Status](https://github.com/mdub/green_log/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/mdub/green_log/actions/workflows/ci.yml)

GreenLog is a logging library for Ruby applications.  It:

- focuses on [structured logging](https://www.thoughtworks.com/radar/techniques/structured-logging) - treating log entries as data
- is optimised for use in modern "cloud-native" applications
- can be used in place of Ruby's stdlib `Logger`

## Design approach

GreenLog:

- [avoids global state](doc/adr/0002-avoid-global-configuration.md)
- avoids mutable objects
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

## Usage

### tl;dr

```ruby
require 'green_log'

logger = GreenLog::Logger.build

logger.info("Stuff happened")
# outputs: I -- Stuff happened
```

### Basic logging

GreenLog implements all the expected logging shortcuts:

```ruby
logger.debug("Nitty gritty detail")
# outputs: D -- Nitty gritty detail
logger.info("Huh, interesting.")
# outputs: I -- Huh, interesting.
logger.warn("Careful now.")
# outputs: W -- Careful now.
logger.error("Oh, that's really not good!")
# outputs: E -- Oh, that's really not good!
logger.fatal("Byeeee ...")
# outputs: F -- Byeeee ...
```

### Adding context

`Logger#with_context` adds detail about the _source_ of log messages.

```ruby
logger = GreenLog::Logger.build.with_context(pid: Process.pid, thread: Thread.current.object_id)
logger.info("Hello")
# outputs: I [pid=13545 thread=70260187418160] -- Hello
```

It can be chained to inject additional context:

```ruby
logger.with_context(request: 16273).info("Handled")
# outputs: I [pid=13545 thread=70260187418160 request=16273] -- Handled
```

Context can also be calculated dynamically, using a block:

```ruby
logger = GreenLog::Logger.build.with_context do
  {
    request_id: Thread.current[:request_id]
  }
end
# outputs: I [pid=13545 thread=70260187418160 request=16273] -- Handled
```

### Including data and exceptions

A Hash of data can be included along with the log message:

```ruby
logger = GreenLog::Logger.build
logger.info("New widget", id: widget.id)
# outputs: I -- New widget [id=12345]
```

And/or, you can attach an exception:

```ruby
begin
  Integer("abc")
rescue => e
  logger.error("parse error", e)
end
# outputs: E -- parse error
#            ! ArgumentError: invalid value for Integer(): "abc"
#              (irb):50:in `Integer'
#              (irb):50:in `irb_binding'
#              ...
```

### Alternate output format

By default GreenLog logs with a human-readable format; specify an alternate `format`
class if you want a different serialisation format. It comes bundled with a JSON writer, e.g.

```ruby
logger = GreenLog::Logger.build(format: GreenLog::JsonWriter)
# OR
logger = GreenLog::Logger.build(format: "json")

logger.info("Structured!", foo: "bar")
```

outputs

```json
{"severity":"INFO","message":"Structured!","data":{"foo":"bar"},"context":{}}
```

### Alternate output destination

Logs go to STDOUT by default; specify `dest` to override, e.g.

```ruby
logger = GreenLog::Logger.build(dest: STDERR)
```

### Null logger

`GreenLog::Logger.null` returns a "null object" Logger, which routes log entries to `/dev/null`.

```ruby
logger = GreenLog::Logger.null
```

### Filtering by log severity

By default all log entries will result in output. You can add a severity-threshold to avoid emitting debug-level log messages, e.g.

```ruby
logger = GreenLog::Logger.build(severity_threshold: :INFO)
# OR
logger = GreenLog::Logger.build.with_severity_threshold(:INFO)

log.debug("Whatever") # ignored
```

### Block form

Rather than passing arguments, you can provide a block to generate log messages:

```ruby
logger.info do
  "generated message"
end
# outputs: I -- generated message
```

The block may be ignored, if a severity-threshold is in effect:

```ruby
logger = GreenLog::Logger.build(severity_threshold: :INFO)

log.debug do
  # not evaluated
end
```

### Compatibility with stdlib Logger

GreenLog includes a backward-compatibile adapter for code written to use Ruby's built-in [`Logger`](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html):

```ruby
require 'green_log/classic_logger'

legacy_logger = logger.to_classic_logger
legacy_logger.warn("Old skool")
# outputs: W -- Old skool
```

### Rack request-logging

GreenLog bundles a Rack middleware - an alternative to [`Rack::CommonLogger`](https://www.rubydoc.info/gems/rack/Rack/CommonLogger) - that generates structured HTTP access logs:

```ruby
require "green_log"
require "green_log/rack/request_logging"

logger = GreenLog::Logger.build(format: "json")
use GreenLog::Rack::RequestLogging, logger
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mdub/green_log.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
