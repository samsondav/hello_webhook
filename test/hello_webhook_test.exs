defmodule HelloWebhookTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest HelloWebhook

  @opts HelloWebhook.Endpoint.init([])

  test "GET /hello" do
    # Create a test connection
    conn = conn(:get, "/hello")

    # Invoke the plug
    conn = HelloWebhook.Endpoint.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, world!"
  end

  test "POST /hello with valid payload" do
    body = Poison.encode!(%{name: "Sam"})

    conn = conn(:post, "/hello", body)
      |> put_req_header("content-type", "application/json")

    conn = HelloWebhook.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Poison.decode!(conn.resp_body) == %{"response" => "Hello, Sam!"}
  end

  test "POST /hello with invalid payload" do
    body = Poison.encode!(%{namu: "Samu"})

    conn = conn(:post, "/hello", body)
      |> put_req_header("content-type", "application/json")

    conn = HelloWebhook.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert Poison.decode!(conn.resp_body) == %{"error" => "Expected a \"name\" key"}
  end
end
