defmodule MathChallenger.Processes.Genserver1 do
  #High-level module that wraps the functionalities what we used with the primitives
  #Genserver - Generic server - In a general view until now, all the process acts as mini servers that sends or receive messages
  #use - to import some behavior in a module


  #GenServer facilitates all the the 'rudimentary' steps to launch and communicate processes.
  #Elixir puts a condition for this: Declare some functions with an specific name in order to help you.
  use GenServer #Import a behavior that identify and declare the existence of some specific functions
  #First specific function to declare yes or yes: init/1 - it will be called when we start the Genserver/Module
  def init(_param) do
    IO.puts("S3.Genserver.Genserver1 started!")
    #IO.inspect(param, label: "Param received") #You can ignore param with _
    #You can add another stuff after this or to replace this but the last line always must be a tuple {:ok, initial_status}
    {:ok, %{count: 1}} #The importance to define what it will be the second element is when i do my send() callings bc by pattern_matching the matched handle_info function will be called
  end

  #To manage messages - Another function to declare: handle_info/2 - It works each time we send a message to the Genserver - The replace for receive do structure
  #As a specific function that Genserver looks when you send something to the running process, pattern matching can be apply.
  #This wont be trigger if you set %{count_2: count} bc it was not launched in the init
  def handle_info(:greet, %{count: count}) do
    IO.puts "Triggered if you call with :greet #1"
    IO.puts("Number of calls: #{count}")
    #The last line always must be a tuple {:noreply, state}
    {:noreply, %{count: count + 1}}
  end

  #The default one: Genserver while doing the matching it pays attention to both parameters, state variable acts as a 'all_type_param'
  def handle_info(:greet, state) do
    IO.puts "Triggered if you call with :greet #2.5"
    #The last line always must be a tuple {:noreply, state}
    {:noreply, state}
  end

  #If we send(pid, :atom) it will be trigger bc the guard when is_atom(msg) the difference is how the state is handling now with a map %{count: count}
  def handle_info(msg, %{count: count}) when is_atom(msg) do
    IO.puts ("Triggered if you send an atom: #{msg}")
    IO.puts("Number of calls: #{count}")
    {:noreply, %{count: count + 1}}
  end

  #This one is the default one
  def handle_info(msg, state) do
    IO.puts ("General handler: #{msg}")
    #The last line always must be a tuple {:noreply, state}
    {:noreply, state}
  end

  #Another curious thing is if you use count in more that 1 function, the counting process keep going... like 'count' is available globally bc yes it was launched in the init.
  #When you execute r(S3.Genserver.Genserver1) you are just recompiling if you do changes, but if these ones affect the init of the process you will not notice the changes: So, you have to re-launch the process


end

#To execute:
#1. iex
#2. c("lib/processes/genserver_1.ex")
#3. {init, pid} = GenServer.start_link(MathChallenger.Processes.Genserver1, {:ok, :start})
#4. send(pid, ...)
#5.  r(S3.Genserver.Genserver1)
