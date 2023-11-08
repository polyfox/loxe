# Loxe

Loxe is [logfmt](https://www.brandur.org/logfmt) logger interface, it is built atop Elixir's standard Logger module.

## Config

As of version 0.4.0, you can configure loxe to filter metadata:

```elixir
config :loxe,
  # By default, if a value cannot be encoded by logfmt, it would normally raise a Protocol.UndefinedError
  # This field can be set to handle those cases differently:
  # * `:raise` the default
  # * `:placeholder` will replace the value with <protocol-unavailable>
  # * `:inspect` will use inspect instead of Logfmt.ValueEncoder if it is not available
  on_protocol_undefined: :raise,
  metadata: [
    only: [
      # keys that should always be included from the metadata
      :just_this,
      :and_this,
      :maybe_this,
    ],
    except: [
      # keys that should always be excluded from the metadata
      :not_this,
      :and_not_this,
    ],
  ]
```

Keep in mind this is a compile-time configuration therefore changing the above during runtime will have no effect.

__Note__ The presence of `loxe.metadata.only` (even if just an empty list) changes the filtering behaviour completely. If present, _every_ key from `Logger.metadata/0` will be rejected by default except those specified in the list.

__Note__ The presence of `loxe.metadata.except` has the default behaviour in which all keys are allowed by default (unless `loxe.metadata.only` is present in which case the default is to reject), except the keys listed.

__Note__ This only affects fields from `Logger.metadata/0`, if you specified the list using Loxe's log functions, it will be present in the log line:

```elixir
Loxe.Logger.metadata not_this: "something", and_not_this: "something-else"

Loxe.Logger.info "hi"
# => msg=hi
Loxe.Logger.info "hi", not_this: "should exist"
# => not_this="should exist" msg=hi
```

## Usage

```elixir
use Loxe.Logger

Loxe.Logger.info "message"
# => msg="message"

Loxe.Logger.info "message", [a: "Egg", b: "Rice"]
# => a="Egg" b="Rice" msg="message"
```

## Installation

```elixir
def deps do
  [
    {:loxe, git: "https://github.com/polyfox/loxe"}
  ]
end
```
