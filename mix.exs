defmodule Cryptocomparex.MixProject do
  use Mix.Project

  def project do
    [
      app: :cryptocomparex,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Cryptocomparex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:tesla, "1.0.0"},
      {:jason, "1.0.0"},
      {:key_tools, "~> 0.4"},
      {:dialyxir, "~> 1.0.0-rc.2", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :cryptocomparex,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["ontofractal"],
      description:
        "Cryptocomparex is an unofficial Elixir/Erlang API client for Cryptocompare API.",
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/cyberpunk-ventures/cryptocomparex",
        "Cyberpunk Ventures" => "http://cyberpunk.ventures"
      }
    ]
  end
end
