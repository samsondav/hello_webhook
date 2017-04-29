defmodule HelloWebhook.Endpoint do
  use Plug.Router
  require Logger

  plug Plug.Logger
  # NOTE: The line below is only necessary if you care about parsing JSON
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    port = Application.fetch_env!(:hello_webhook, :port)
    {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, [], port: port)
  end

  get "/hello" do
    send_resp(conn, 200, "Hello, world!")
  end

  post "/hello" do
    {status, body} =
      case conn.body_params do
        %{"name" => name} -> {200, say_hello(name)}
        _ -> {422, missing_name()}
      end
    send_resp(conn, status, body)
  end

  defp say_hello(name) do
    Poison.encode!(%{response: "Hello, #{name}!"})
  end

  defp missing_name do
    Poison.encode!(%{error: "Expected a \"name\" key"})
  end
end
