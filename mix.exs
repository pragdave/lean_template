defmodule LeanTemplate.Mixfile do
  use Mix.Project

  @version "0.1.3"
  @deps    []

  ############################################################
  
  def project do
    in_production = Mix.env == :prod
    [
      app:     :lean_template,
      version: @version,
      deps:    @deps,
      elixir:  "~> 1.5-dev",
      build_embedded:  in_production,
      start_permanent: in_production,
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

end
