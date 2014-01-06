defmodule RdmaBench.PingSupervisor do
    use Supervisor.Behaviour

    def start_link(pong_sup_pid) do
        :supervisor.start_link(__MODULE__, pong_sup_pid)
    end

    def init(pong_sup_pid) do
        children = Enum.map 1..100, fn(_) -> worker(RdmaBench.PingServer, [pong_sup_pid], id: make_ref()) end
        supervise(children, strategy: :one_for_one)
    end
end
