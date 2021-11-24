# Loxe

Loxe is a layer over Elixir's Logger module formatting its parameters as logfmt.

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
