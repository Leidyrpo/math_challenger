defmodule MathChallenger.Processes.Game.HangmanUtils do
  def select_word() do
    Enum.random(["cafetera", "mariposa","lavacara","cuaderno", "televisor", "cuaderno","calendario"])
  end

  def abc_points() do
    vocales = ["a", "e", "i", "o", "u"]
    alphabet = for letter <- String.graphemes("abcdefghijklmnopqrstuvwxyz") do
      case letter in vocales do
        true -> {letter, 5}
        false -> {letter, 3}
      end
    end

    Map.new(alphabet)
  end

  def word_to_play() do
    selW = select_word()
    spaces = String.duplicate("_", String.length(selW)-2)
    {selW, String.first(selW) <> spaces <> String.last(selW)}
  end

  def update_word(word_game, ing_l, selW) do
    mods = n_modifies(selW, ing_l)
    set_modify(mods, length(mods), word_game)
  end

  def update_word_clue(word_game, selW) do
    pos_clue = String.codepoints(word_game) |> Enum.with_index(fn elem, index -> {elem, index} end) |> Enum.filter(fn {l,_i} -> l == "_" end) |> Enum.random() |> elem(1)
    ing_l = String.codepoints(selW) |> Enum.at(pos_clue)
    mods = n_modifies(selW, ing_l)
    set_modify(mods, length(mods), word_game)
  end


  #Función para filtrar las letras a reemplazar
  defp n_modifies(selW, ing_l) do
    l_selW = String.codepoints(selW)
    Enum.filter(Enum.with_index(l_selW), fn(t) -> elem(t,0) == ing_l end)
  end

  #Función para realizar las modificaciones
  defp set_modify(l_n_mod, tot, word_game) when tot > 0 do
    t = Enum.at(l_n_mod, length(l_n_mod)-tot)
    act = String.codepoints(word_game)
          |> List.replace_at(elem(t,1), elem(t,0))
          |> Enum.join("")
    tot = tot - 1
    set_modify(l_n_mod, tot, act)
  end

  defp set_modify(_, 0, act), do: act

  def victim() do
    """
      ____
     |    |
     1    |
    324   |
    5 6   |
         _|_
    """
  end

  def update_victim(oport, drawing) when oport <=6 do
    partes = ["O", "|", "/", "\\", "/", "\\"]
    String.replace(drawing, to_string(oport), Enum.at(partes, oport - 1))
  end

  def update_victim(_, drawing) , do: drawing
end

#1. c("lib/processes/game/hangman_utils.ex")