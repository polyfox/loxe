samples = [
  {"Empty", []}, # nothing
  {"1 Key", [key: "value"]}, # single key
  {"2 Keys", [key: "value", key2: "value2"]}, # 2 keys
  {"3 Keys", [key: "value", key2: "value2", key3: "value3"]}, # 3 keys
  {"3 Keys with escapable", [key: "Hello, World", key2: "abc=def", key3: "\\abc"]} # 3 values but they need to be escaped
]

Enum.each(samples, fn {label, sample} ->
  IO.puts "Bench #{label}"
  Benchee.run(
    %{
      "logfmt.encode" => fn ->
        Logfmt.Encoder.encode(sample)
      end,
      "loxe.logfmt.encode" => fn ->
        Loxe.Logfmt.Encoder.encode(sample)
      end,
    },
    warmup: 2,
    time: 7,
    memory_time: 7
  )
end)
