defmodule MathChallenger.Processes.Game.HangmanServer do
  import MathChallenger.Processes.Game.HangmanUtils
  use GenServer

  #--------THE GAME--------------
  def init_game() do
    {:ok, pid} = start_server()
    {selW,w_game} = word_to_play()
    game(w_game, selW, 0, 0, victim(),pid)
  end

  defp game(word_game, selW, oport, ptos, drawing, pid) when word_game != selW and oport < 6  do
    IO.puts("Hangman v4.5")
    IO.puts(word_game)
    IO.puts(drawing)
    IO.puts("Puntos: #{ptos}}")

    ing_l = IO.gets("Ingrese una letra o solicita una pista ([P]): ") |> String.trim #Ingresa [P] para que el juego te dé la pista

    ptos_x_ing = case ing_l do
      "[P]" -> 0
      _ -> Map.get(abc_points(), String.downcase(ing_l))
    end

    {up_word_game, oport, ptos, drawing} = case {ing_l, String.contains?(selW, ing_l)} do
      {ing_l, true} ->
        {update_word(word_game, ing_l, selW), oport, ptos + ptos_x_ing, drawing}

      {"[P]", false} ->
        {give_clue(word_game, selW, pid), oport, ptos, drawing}

      {_, false} ->
        {word_game, oport + 1, ptos, update_victim(oport + 1, drawing)}
    end


    game(up_word_game, selW, oport, ptos, drawing, pid)

  end

  #"Por hacer: Editar lo que realizan estas funciones de modo que se detenga el servidor llamando a stop_server(result) y mostrando el resultado final de la partida "

  defp game(word_game, selW, _ , ptos, _, pid) when word_game == selW do
    result= "Ganaste, puntaje: #{ptos}"
    IO.puts(result)
    stop_server(result, pid)
      {:guessed, selW, ptos}
  end

  defp game(_, _, oport, ptos, _, pid) when oport == 6 do
    result= "Perdiste, puntaje: #{ptos}"
    IO.puts(result)
    stop_server(result, pid)
      {:gameover, ptos}
  end

  #----------------GENSERVER STUFF-------------------------

  def start_server do
    IO.puts("Inicializando el servidor")
    GenServer.start_link(__MODULE__, []) #Iniciamos con 3 pistas disponibles

  end

  def init(_param) do
    IO.puts("Hangman game is starting...")
    IO.puts("Inicializamos con 3 pistas disponibles ")
    {:ok, %{pistas_disponibles: 3}}
  end

  def handle_call({word_game, selW}, _from, state) do
    pistas_disponibles = Map.get(state, :pistas_disponibles, 0)

    case pistas_disponibles do
      0 -> IO.puts("No te quedan pistas disponibles")
      n when n > 0 -> IO.puts("Tienes #{n} pistas disponibles")
    end

    word_up = update_word_clue(word_game, selW)

    new_state = Map.update!(state, :pistas_disponibles, fn n -> n - 1 end)

    {:reply, word_up, new_state}
  end

  defp give_clue(word_game, selW, pid) do
    IO.puts("Solicitando pista...")
    GenServer.call(pid, {word_game, selW})

  end

  defp stop_server(_result, pid) do
    IO.puts("Hangman game is stoping...")
    result_stop=GenServer.stop(pid)
    IO.inspect(result_stop, label: "Resultado de pistas")
  end

end


#1. c("lib/processes/game/hangman_utils.ex")
#2. c("lib/processes/game/hangman_server.ex")
#3. alias MathChallenger.Processes.Game.HangmanServer
#4. {:ok,pid} = HangmanServer.start_server()
#5. HangmanServer.init_game

