defmodule RdmaBench.PongServer do
    use GenServer.Behaviour

    def start_link do
        :gen_server.start_link(__MODULE__, [], [])
    end

    def ping(pong_server) do
        :gen_server.call(pong_server, :ping)
    end

    def handle_call(:ping, _from, state) do
        {:reply, :pong, state}
    end

    def handle_call(request, from, state) do
        super(request, from, state)
    end
end
