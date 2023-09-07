defmodule MathChallenger.Processes.Game.HangmanServer do
  import MathChallenger.Processes.Game.HangmanUtils
  use GenServer

  #--------THE GAME--------------
  def init_game() do
    {selW,w_game} = word_to_play()
    game(w_game, selW, 0, 0, victim())
  end

  defp game(word_game, selW, oport, ptos, drawing) when word_game != selW and oport < 6 do
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
      {ing_l, true} -> {update_word(word_game, ing_l, selW), oport, ptos+ptos_x_ing, drawing}
      #Por hacer: Incluir el caso para solicitar pistas al servidor (llamar a give_clue) y que calce con la lógica del case para seguir llamando a game() - 1p
      {_, false} -> {word_game, oport + 1, ptos, update_victim(oport+1, drawing) }
    end

    game(up_word_game, selW, oport, ptos, drawing)

  end

  #To do: Editar lo que realizan estas funciones de modo que se detenga el servidor llamando a stop_server(result) y mostrando el resultado final de la partida - 1p
  defp game(word_game, selW, _ , ptos, _) when word_game == selW, do: {:guessed, selW, ptos}

  defp game(_, _, oport, ptos, _ ) when oport == 6, do: {:gameover, ptos}

  #----------------GENSERVER STUFF-------------------------

  def start_server do
    IO.puts("Por hacer: Inicializar el servidor - 1p")
  end

  def init(_param) do
    IO.puts("Hangman game is starting...")
    IO.puts("Por hacer: Definir el estado inicial de 3 para solicitar pistas - 1p")
    #{:ok, 3}

  end

  def handle_call({word_game, selW}, _from, status) do
    word_up = update_word_clue(word_game, selW) # Aqui ya está la palabra en juego con la pista ya puesta
    IO.puts("Por hacer: Desarrollar la lógica para ir disminuyendo la cantidad de pistas y mostrar un mensaje cuando le quden n pistas por pedir o ninguna - 5p")
    #{:reply, result, status - 1}
  end

  defp give_clue(word_game, selW) do
    IO.puts("Por hacer: Realizar el llamado correcto para llamar a handle_call - 1p")

  end

  defp stop_server(result) do
    IO.puts("Hangman game is stoping...")
    GenServer.stop(HangmanServer)
    result
  end

end

#2. c("lib/processes/game/hangman_server.ex")
#3. alias MathChallenger.Processes.Game.HangmanServer
#4. HangmanServer.init_game