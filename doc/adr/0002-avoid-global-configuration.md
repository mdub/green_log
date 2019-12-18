# 2. Avoid global configuration

Date: 2019-12-18

## Status

Accepted

## Context

Applications require a way to configure their logging, e.g. what should be logged, where should logs be sent, and how should they be formatted.

Some Ruby logging libraries involve global configuration, and other state, e.g.

```ruby
require 'some_logger'
SomeLogger.default_level = :trace
SomeLogger.add_appender(file_name: 'development.log', formatter: :color)
SomeLogger["MyClass"].info("Stuff happened")
```

but global state can have unintended consequences, and make testing difficult.

## Decision

GreenLog will avoid global configuration. `GreenLog::Logger` instances should be created and configured explicitly, and injected as dependencies where needed.

## Consequences

- Testing of logging logic should be straightforward.
- Libraries and applications can make their own logging arrangements.

BUT

- Applications will need to determine their own conventions for configuration of logging.
