defmodule RdmaBench.StatsSupervisor do
    use Supervisor.Behaviour

    def start_link do
        :supervisor.start_link({:global, :stats_supervisor}, __MODULE__, [])
    end

    def init([]) do
        children = [worker(RdmaBench.StatsServer, [])]
        supervise(children, strategy: :one_for_one)
    end
end
