# 0.4.0

* Added `:loxe` config with `:metadata` field to filter metadata fields from logs
* Added `:loxe` config `:on_protocol_undefined` which controls the behaviour of Logfmt.ValueEncoder for values that don't have an implementation, see README for more details.
* Added loxe version of `Logfmt.encode/1` it has been optimized for cpu performance but uses more memory (as bad as 2x, but this is logging it won't be sticking around for long anyway)

# 0.3.1

* Fixed macro quoting issue

# 0.3.0

* `Loxe.Formatter.format/2` will now handle any combination of arguments:
  * iodata and binary are treated as message components
  * keyword lists will act as normal

# 0.2.0

* Last stable version
