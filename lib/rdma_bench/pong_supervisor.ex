defmodule RdmaBench.PongSupervisor do
    use Supervisor.Behaviour

    def start_link do
        :supervisor.start_link(__MODULE__, [])
    end

    def start_pong_server(pong_sup_pid) do
        :supervisor.start_child(pong_sup_pid, [])
    end

    def init(_args) do
        supervise([worker(RdmaBench.PongServer, [])], strategy: :simple_one_for_one)
    end
end
