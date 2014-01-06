defmodule RdmaBench.StatsServer do
    use GenServer.Behaviour

    defrecord State, count: 0

    def start_link do
        :gen_server.start_link({:global, :stats_server}, __MODULE__, [], [])
    end

    def report(count) do
        :gen_server.cast({:global, :stats_server}, {:report, count})
    end

    def init(_args) do
        spawn_link(__MODULE__, :print_loop, [])
        {:ok, State.new}
    end

    def handle_cast({:report, count}, state) do
        state = state.update count: state.count + count
        {:noreply, state}
    end

    def handle_cast(:print, state) do
        info = """
        In the last second...
           we exchanged ~B messages between ~B nodes.
        That is ~B messages per second per node...
           and ~B microseconds per message.
        """

        num_nodes = length(Node.list) + 1
        count_per_node = state.count / num_nodes
        micros_per_msg = if count_per_node > 0 do
            1000000 / count_per_node
        else
            0
        end

        :error_logger.info_msg(info, [
            state.count, num_nodes,
            Float.floor(count_per_node),
            Float.floor(micros_per_msg),
        ])

        {:noreply, state.update(count: 0)}
    end

    def handle_cast(request, state) do
        super(request, state)
    end

    def print_loop do
        :timer.sleep(1000)
        :gen_server.cast({:global, :stats_server}, :print)
        print_loop
    end
end
