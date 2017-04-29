defmodule HelloWebhook do
  @moduledoc "The main OTP application for HelloWebhook"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(HelloWebhook.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: HexVersion.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
