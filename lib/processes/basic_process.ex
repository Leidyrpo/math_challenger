defmodule MathChallenger.Processes.BasicProcess do
  def run do
    receive do
      {sender_pid, message} -> IO.puts "Received in run: #{message} from #{inspect(sender_pid)}"
      send(sender_pid, message)
    end
  end
end

alias MathChallenger.Processes.BasicProcess
#Spawn a new process
pid = spawn(BasicProcess, :run, [])

#Send a message
send(pid, {self(), "Hello there~"})

#Wait for a response
receive do
  message -> IO.puts("Received #{message}")
after
  5000 -> IO.puts "No response received after 5s"
end

#c("lib/processes/basic_process.ex")