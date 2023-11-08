import Config

config :loxe,
  on_protocol_undefined: :placeholder,
  metadata: [
    except: [
      :hide_me,
    ]
  ]
