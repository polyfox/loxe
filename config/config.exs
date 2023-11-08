import Config

config :loxe,
  # available values:
  # * :raise - the default behaviour if a value cannot be encoded, it will raise
  # * :placeholder - if a value cannot be encoded, it will be replaced with <encode-error>
  # * :inspect  - if a value cannot be encoded normally, use Kernel.inspect/1 instead
  on_protocol_undefined: :raise,
  metadata: []

import_config "#{Mix.env()}.exs"
