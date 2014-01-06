# RdmaBench #
This program is a simple messaging benchmark for Erlang, written in Elixir.
For each node in the Erlang cluster, the program spawns a number of processes
that just do RPCs in a loop.  The number of RPCs are recorded and tracked by a
global stats server which outputs total message counts every second.

## Building ##
With Elixir installed, the dependencies can be pulled down and built with Mix:

    % export CFLAGS="-I/path/to/ofed/include"
    % export LDFLAGS="-L/path/to/ofed/lib"
    % mix deps.get

Then the program itself can be built:

    % mix compile

## Running ##
The program is built on the assumption of running on UMD clusters.  The scripts
`rdma_bench` and `rdma_bench.pbs` should give you a good idea of how to run it
manually though.  If all goes well, the program will output information in the
form of:

    =INFO REPORT==== 6-Jan-2014::11:44:06 ===
    In the last second...
       we exchanged 360690 messages between 4 nodes.
    That is 90172 messages per second per node...
       and 11 microseconds per message.
