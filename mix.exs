defmodule Fiddle.MixProject do
  use Mix.Project

  def project do
    [
      app: :fiddle,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Fiddle.Application, []}
    ]
  end

  defp deps do
    [
      {:nostrum, github: "Kraigie/nostrum"}
    ]
  end
end
