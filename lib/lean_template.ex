defmodule LeanTemplate.Helpers do

  @deps """
  \@deps  [
      # eg:  { :my_dep, "~> 0.3.0" }   –or–
      # { :my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0" }
    ]
  """
  def standard_deps(), do: @deps

end

defmodule LeanTemplate do

  import LeanTemplate.Helpers
  use Mix.Templates

  ############################################################ README
  
  embed_template :readme, """
  # <%= @mod %>

  **TODO: Add description**
  <%= if @app do %>
  ## Installation

  If [available in Hex](https://hex.pm/docs/publish), the package can be installed
  by adding `<%= @app %>` to your list of dependencies in `mix.exs`:

  ```elixir
  \@deps [
    { :<%= @app %>, "~> 0.1.0" }
  ]
  end
  ```
  <% end %>
  """

  ############################################################ .gitignore

  embed_text :gitignore, """
  # Ask git to ignore artifacts that are created by the Elixir tools

  #                compiled artifacts
  /_build/

  #                test coverage assets
  /cover/

  #                local copies of dependencies
  /deps/

  #                generated documentation (from things such as ex_doc)
  /doc/

  #                in case you like to edit your project deps locally
  /.fetch

  #                dumps created if the interpreter crashes
  erl_crash.dump

  #                archives built by "mix archive.build"
  *.ez
  """


  ############################################################ mix.exs

  embed_template :mixfile, """
  defmodule <%= @mod %>.Mixfile do
    use Mix.Project

    \@version   "0.1.0"

    #{ standard_deps() }

    ############################################################

    def project do
      in_production Mix.env == :prod
      [
        app:      :<%= @app %>,
        version:  \@version,
        elixir:   "~> <%= @version %>",
        deps:     \@deps,
        build_embedded:  in_production,
        start_permanent: in_production,
      ]
    end

    def application do
      <%= @otp_app %>
    end
  end
  """

  ############################################################

  embed_template :mixfile_apps, """
  defmodule <%= @mod %>.Mixfile do
    use Mix.Project

    \@version "0.1.0"

    #{ standard_deps() }

    ############################################################

    def project do
      in_production Mix..env == :prod
      app_base = "../.."

      [
        app:     :<%= @app %>,
        version: \@version,
        deps:    \@deps,
        build_path:      "\#{ app_base }/_build",
        config_path:     "\#{ app_base }/config/config.exs",
        deps_path:       "\#{ app_base }/deps",
        lockfile:        "\#{ app_base }/mix.lock",
        elixir:          "~> <%= @version %>",
        build_embedded:  in_production
        start_permanent: in_production
      ]
    end

    def application do
      <%= @otp_app %>
    end

  end
  """

  ############################################################

  embed_template :mixfile_umbrella, """
  defmodule <%= @mod %>.Mixfile do
    use Mix.Project

    #{ standard_deps() }

    ############################################################

    def project do
      in_production Mix.env == :prod

      [
        apps_path:       "apps",
        deps:            @deps,
        build_embedded:  in_production
        start_permanent: in_production,
      ]
    end

  end
  """


  ############################################################


  embed_template :config, ~S"""
  use Mix.Config
  """

  embed_template :config_umbrella, ~S"""
  use Mix.Config
  """

  ############################################################

  embed_template :lib, """
  defmodule <%= @mod %> do
  end
  """

  ############################################################

  embed_template :lib_app, """
  defmodule <%= @mod %>.Application do
    @moduledoc false

    use Application

    def start(_type, _args) do
      import Supervisor.Spec, warn: false

      children = [
        # worker(<%= @mod %>.Worker, [arg1, arg2, arg3]) ...
      ]

      opts = [
        strategy: :one_for_one, 
        name: <%= @mod %>.Supervisor
      ]

      Supervisor.start_link(children, opts)
    end
  end
  """

  ############################################################
  
  embed_template :test, """
  defmodule <%= @mod %>Test do
    use ExUnit.Case
    # doctest <%= @mod %>

  end
  """

    
end
