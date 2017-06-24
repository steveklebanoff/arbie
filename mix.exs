defmodule Arbie.Mixfile do
  use Mix.Project

  def project do
    [app: :arbie,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     escript: escript()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :instream],
     mod: {Arbie.Application, []}]
  end

  def escript do
    [main_module: Arbie.Script]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:websockex, "~> 0.1.3"},
     {:poison, "~> 3.0"},
     {:instream, "~> 0.15"},
     {:distillery, "~> 1.0"}]
  end
end
