defmodule RdmaBench do
    use Application.Behaviour

    def start(_type, _args) do
        :timer.apply_after(30000, :init, :stop, [])

        reply = RdmaBench.AppSupervisor.start_link
        RdmaBench.Controller.join_cluster
        reply
    end
end
