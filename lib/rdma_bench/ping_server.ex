defmodule RdmaBench.PingServer do
    use GenServer.Behaviour

    defrecord State, pong_server: nil, count: 0
    
    def start_link(pong_sup_pid) do
        :gen_server.start_link(__MODULE__, pong_sup_pid, [])
    end

    def init(pong_sup_pid) do
        {:ok, pong_server} = RdmaBench.PongSupervisor.start_pong_server(pong_sup_pid)
        spawn_link(__MODULE__, :ping_loop, [self])
        spawn_link(__MODULE__, :report_loop, [self])
        {:ok, State.new(pong_server: pong_server)}
    end

    def handle_call(:ping, _from, state) do
        try do
            RdmaBench.PongServer.ping(state.pong_server)
            {:reply, :ok, state.update(count: state.count + 1)}
        catch
            # Handle death of pong server.
            _, _ -> {:stop, :shutdown, :ok, state}
        end
    end

    def handle_call(request, from, state) do
        super(request, from, state)
    end

    def handle_cast(:report, state) do
        RdmaBench.StatsServer.report(state.count)
        {:noreply, state.update(count: 0)}
    end

    def handle_cast(request, state) do
        super(request, state)
    end

    def ping_loop(ping_server) do
        :gen_server.call(ping_server, :ping)
        ping_loop(ping_server)
    end

    def report_loop(ping_server) do
        :timer.sleep(500)
        :gen_server.cast(ping_server, :report)
        report_loop(ping_server)
    end
end
