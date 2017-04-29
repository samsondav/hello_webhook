defmodule HelloWebhookTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest HelloWebhook

  @opts HelloWebhook.Endpoint.init([])

  test "responds with hello" do
    body = Poison.encode!(%{name: "Sam"})

    # Create a test connection
    conn = conn(:post, "/hello", body)
      |> put_req_header("content-type", "application/json")

    # Invoke the plug
    conn = HelloWebhook.Endpoint.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert Poison.decode!(conn.resp_body) == %{"response" => "Hello, Sam!"}
  end

  test "responds with error for missing name" do
    body = Poison.encode!(%{namu: "Samu"})

    # Create a test connection
    conn = conn(:post, "/hello", body)
      |> put_req_header("content-type", "application/json")

    # Invoke the plug
    conn = HelloWebhook.Endpoint.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 422
    assert Poison.decode!(conn.resp_body) == %{"error" => "Expected a \"name\" key"}
  end
end
