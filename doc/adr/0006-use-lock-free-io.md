# 6. Use lock-free IO

Date: 2019-12-24

## Status

Accepted

## Context

We want to be able to write log entries (to file, or STDOUT), without them being interleaved.

But also, we want logging to perform well.

## Decision

_Unlike_ the Ruby standard `Logger`, GreenLog will use a [lock-free logging](https://www.jstorimer.com/blogs/workingwithcode/7982047-is-lock-free-logging-safe) approach. That is, we will:

- avoid using of mutexes to serialise output
- perform atomic writes to `IO` streams (using `<<`)

## Consequences

- IO code is simple.
- Performance should be good.

But:

- We risk interleaving of log entries if the size of the (serialized) entries gets over `PIPE_BUF_MAX` (1Mb on Linux).
