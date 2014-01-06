defmodule RdmaBench.Controller do
    use GenServer.Behaviour

    defrecord State, stats_ref: nil

    def start_link do
        :gen_server.start_link({:local, :controller}, __MODULE__, [], [])
    end

    def init(_args) do
        state = start_stats_supervisor(State.new)
        {:ok, state}
    end

    def join_cluster do
        :gen_server.abcast(Node.list, :controller, {:join_cluster, Node.self})
    end

    def handle_cast({:join_cluster, node}, state) do
        :error_logger.info_msg("Got request to join cluster from ~p.~n", [node])

        {:ok, local_node_sup_pid} = RdmaBench.AppSupervisor.start_local_node_supervisor(node)
        {:ok, remote_node_sup_pid} = RdmaBench.AppSupervisor.start_remote_node_supervisor(node, Node.self)

        # Start pinging in both directions.
        RdmaBench.NodeSupervisor.start_ping_pong(local_node_sup_pid, remote_node_sup_pid)
        RdmaBench.NodeSupervisor.start_ping_pong(remote_node_sup_pid, local_node_sup_pid)

        {:noreply, state}
    end

    def handle_cast(request, state) do
        super(request, state)
    end

    def handle_info({:DOWN, stats_ref, _, _, _}, state = State[stats_ref: stats_ref]) do
        state = start_stats_supervisor(state)
        {:noreply, state}
    end

    def handle_info(info, state) do
        super(info, state)
    end

    defp start_stats_supervisor(state) do
        case RdmaBench.StatsSupervisor.start_link do
            {:error, {:already_started, pid}} ->
                stats_ref = Process.monitor(pid)
                state.stats_ref(stats_ref)
            _other ->
                state
        end
    end
end
