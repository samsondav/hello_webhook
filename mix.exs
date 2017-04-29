defmodule HelloWebhook.Mixfile do
  use Mix.Project

  def project do
    [app: :hello_webhook,
     version: "0.1.0",
     elixir: "~> 1.4", # yours may differ
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {HelloWebhook, []}] # This tells OTP which module contains our main application, and any arguments we want to pass to it
  end

  # The version numbers listed here are latest at the time of writing, you
  # should check each project and use the latest version in your code.
  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.3"},
      {:poison, "~> 3.0"}, # NOTE: Poison is necessary only if you care about parsing/generating JSON
    ]
  end
end
