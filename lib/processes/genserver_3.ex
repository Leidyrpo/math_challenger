defmodule MathChallenger.Processes.Genserver3 do
  #Have you wonder what is the order to use handle_cast/info/call?
  #handle_info: Just for manage system messages: Ex - To notify monitors that something happend
  #handle_cast: Do not provide an specific answer. It always answers ok bc yes, or bc nope but you don't know what really happend
  #handle_call: When you always expect an answer - The predilected one bc it can also handle :noreply - we don't have/still not an answer

  #With the previous concepts clear, now let's talk about the tuples that these functions returns
  #Things can be more than :reply or :noreply

  #GenServer provides some atoms to say that something went wrong
  #Let's check init - In normal conditions it always returns :ok, but not the only one
  use GenServer
  def init(_param) do
    IO.puts("MathChallenger.Processes.Genserver3 started!")
    Process.sleep(3000)
    #{:ok, %{count: 0}}
    {:ok, %{count: 0}, 1500}# - You can also manipulate how much are you waiting to finished inside the function and handle that 'log' using  a handle_info. Not matching with [timeout: xxxx]
    #{:stop, "Something needed it still not ready..."} #If the start is linked, it will fail and restart the iex
    #:ignore - Well, the atom is pretty intuitive: If something goes fine or not, it still going
  end

  def handle_info(msg, state) do
    IO.inspect(msg, label: "INFO")
    {:noreply, state}
  end

  def start_process do
    GenServer.start_link(S3.Genserver.Genserver3, [])
  end

  #Adding the Process.sleep(3000) and sending [timeout: 2500] we force a failure that drops as result a tuple {:error, :timeout} in this case
  def start_process_fail do
    GenServer.start_link(S3.Genserver.Genserver3, [], [timeout: 2500])
  end
end

#To execute:
#1. iex
#2. c("lib/processes/genserver_3.ex")
#3. r(S3.Genserver.Genserver3)