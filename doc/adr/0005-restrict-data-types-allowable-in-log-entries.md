# 5. Restrict data-types allowable in log entries

Date: 2019-12-21

## Status

Accepted

## Context

GreenLog allows data to be attached to log entries, either as "context", or "data" associated with the logged event.

Log entries may be consumed by a variety of "handlers", which

## Decision

To make the job of "handlers" easier, GreenLog will restrict the type of value usable as log "context" or "data" to:

- `true`/`false`
- `Numeric`
- `String`
- `Time`
- `Hash` (with `String` or `Symbol` keys)

## Consequences

- Other data must be converted to one of these types before inclusion in log entries.
