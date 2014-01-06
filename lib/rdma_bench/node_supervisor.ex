defmodule RdmaBench.NodeSupervisor do
    use Supervisor.Behaviour

    def start_link do
        :supervisor.start_link(__MODULE__, [])
    end

    def start_ping_pong(local_node_sup_pid, remote_node_sup_pid) do
        case :supervisor.start_child(remote_node_sup_pid, supervisor(RdmaBench.PongSupervisor, [], restart: :temporary)) do
            {:ok, pong_sup_pid} ->
                :supervisor.start_child(local_node_sup_pid, supervisor(RdmaBench.PingSupervisor, [pong_sup_pid], restart: :temporary))
            _ ->
                # The pong supervisor is probably already started.
                :ok
        end
    end

    def init(_args) do
        supervise([], strategy: :one_for_all)
    end
end
