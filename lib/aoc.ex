defmodule AoC do
  def input(year, day) do
    ["lib", "aoc", "year_#{year}", "day_#{day}_input.txt"]
    |> Path.join()
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
