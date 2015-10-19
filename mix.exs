defmodule Lovmx.Mixfile do
  use Mix.Project

  def project do
    [app: :lovmx,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     package: package,
     description: "Orbital Magic for Cloud Apps.",
     docs: [readme: true, main: "README.magic"],
     deps: deps]
  end

  defp package do
  [# These are the default files included in the package
    files: ["boot","config", "console", "EXAMPLE.exs", "lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*", "shell", "words"],
    maintainers: ["Silljays"],
    licenses: ["Apache 2.0"],
    links: %{"GitHub" => "https://github.com/silljays/lovmx",
    "Docs" => "https://www.lovmx.com/help"}]
  end
    
  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [ mod: 
      { Lovmx, [] },
      applications: [
      :uuid,
      :logger,
      :cowboy,
      :plug,
      :httpotion,
      :mongodb_ecto, 
      :ecto,
      :webassembly,
      :maru,
      :moment,
    ]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [ {:uuid,         "~> 1.0", override: false}, 
      {:cowboy,       [hex_app: :cowboy]},
      {:plug,         [optional: false, hex: :plug]},
      {:ibrowse,      github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion,    "~> 2.1.0"},
      {:mongodb_ecto, "~> 0.1"},
      {:ecto,         "~> 1.0"},
      {:poison,       hex: :poison, override: false},
      {:webassembly,  "~> 0.5.0"},
      {:maru,         "~> 0.8"},
      {:moment,       github: "atabary/moment"},
      {:pretty_hex,   github: "polsab/pretty_hex"},
      {:cmark,       hex: :cmark},
      
      # {:exrm,         "~> 0.19.6"},
      # 
      # {:earmark,      ">= 0.0.0",   only: [:dev, :test]},
      # {:ex_doc,       ">= 0.0.0",   only: :dev},
      # {:excoveralls,  "~> 0.3",     only: [:dev, :test]},
      # {:dialyze, "~> 0.2.0"},
      # {:socket,       github: "meh/elixir-socket"},
      # {:connection,   "1.0.0-rc.1", [optional: false, hex: :connection]},
      
      # deploy
      # {:fleet_api,    github: "jordan0day/fleet-api"},
    ]
  end
end
