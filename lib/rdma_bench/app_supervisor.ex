defmodule RdmaBench.AppSupervisor do
    use Supervisor.Behaviour

    def start_link do
        :supervisor.start_link({:local, :app_supervisor}, __MODULE__, [])
    end

    def start_local_node_supervisor(node) do
        start_node_supervisor(:app_supervisor, node)
    end

    def start_remote_node_supervisor(remote_node, node) do
        start_node_supervisor({:app_supervisor, remote_node}, node)
    end

    defp start_node_supervisor(where, node) do
        case :supervisor.start_child(where, supervisor(RdmaBench.NodeSupervisor, [], restart: :temporary, id: node)) do 
            {:error, {:already_started, node_sup_pid}} ->
                {:ok, node_sup_pid}
            other ->
                other
        end
    end

    def init([]) do
        children = [worker(RdmaBench.Controller, [])]
        supervise(children, strategy: :one_for_one)
    end
end
