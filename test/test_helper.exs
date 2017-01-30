ExUnit.start formatters: [
  ExUnit.CLIFormatter,
  JUnitFormatter,
  ExUnitNotifier
]

Ecto.Adapters.SQL.Sandbox.mode(Songbox.Repo, :manual)
