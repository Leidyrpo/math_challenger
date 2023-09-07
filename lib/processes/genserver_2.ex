defmodule MathChallenger.Processes.Genserver2 do
  #Until this point during the usage of GenServer we still don't know who sends a message or to do it you must send self()
  #handle_info it will not be a future election but just for service message, instead we must use handle_call()
  #msg: the mesage - from: which sends -the pid that the calls provides.- not need to set self() but another primitive - state: in case you want to manipulate
  #Technically with this we can say we establish a client-server dynamic
  #Keep in mind that handle_calls have a default timeout of 5000ms in order to not keep listening forever
  #Process.sleep(ms)
  #----------
  #def handle_call(msg, from, state) do
  #  {:reply, _, state}
  #end
  #----------

  #To not wait for an answer when we sent a message
  #---------
  #def handle_cast(msg, state) do
  #  {:noreply, state}
  #end
  #---------
  use GenServer

  def start_link([]) do #Renamed before was start_calculator
    GenServer.start_link(__MODULE__, [], name: GCalculator)
  end

  def init(_param) do
    IO.puts("S3.Genserver.Genserver2 started!")
    {:ok, %{called: {:op, 0, 0}} }
  end

  def handle_call({op, n1, n2}, _from, %{called: _called}) do
    %{called: called} = %{called: {op, n1, n2}}
    result = case {op, n1, n2} do
      {:+, n1, n2} -> n1 + n2
      {:-, n1, n2} -> n1 - n2
      {:x, n1, n2} -> n1 * n2
      {:/, _, 0} -> :infinity
      {:/, n1, n2} -> n1 / n2
    end
    IO.inspect(called, label: "Processed")
    {:reply, result, %{called: {op, n1, n2}}}
  end

  #def handle_cast(:reset, %{called: _called} ) do
  #  %{called: called} = %{called: {:op, 0, 0}}
  #  IO.puts("Re-starting...")
  #  Process.sleep(1000)
  #  IO.inspect(called, label: "Re-started")
  #  {:noreply, %{called: called}}
  #end

  #Now let's talk about wrapping GenServer in custom functions - Let's remake the calculator:
  def calculator(op, n1, n2) do
    GenServer.call(GCalculator, {op, n1, n2})
  end

  #def restart(pid) do
  #  GenServer.cast(pid, :reset)
  #end



end

#To execute:
#1. iex
#2. c("lib/processes/genserver_2.ex")
#3. {init, pid} = GenServer.start_link(MathChallenger.Processes.Genserver2, {:ok, :start})
#4. GenServer.call(pid, msg) | GenServer.call(pid, msd, ms-that-the-call-must-last | :infinity) - to call handle_call definitions
#5. GenServer.cast(pid, msg) - to call handle_cast definitions
#5. Process.alive?(pid)
#6. flush()
#7. r(S3.Genserver.Genserver2)