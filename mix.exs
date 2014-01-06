defmodule RdmaBench.Mixfile do
    use Mix.Project

    def project, do: [
        app: :rdma_bench,
        version: "0.0.1",
        elixir: "~> 0.12.0",
        deps: deps,
    ]

    # Configuration for the OTP application
    def application, do: [
        registered: [],
        mod: {RdmaBench, []},
    ]

    # Returns the list of dependencies in the format:
    # {:foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1"}
    #
    # To specify particular versions, regardless of the tag, do:
    # {:barbat, "~> 0.1", github: "elixir-lang/barbat"}
    defp deps, do: [
        {:rdma_dist, github: "MrStaticVoid/rdma_dist"},
    ]
end
