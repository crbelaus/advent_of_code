defmodule AdventOfCode do
  def input(year, day) do
    ["lib", "#{year}", "day-#{day}", "day-#{day}-input.txt"]
    |> Path.join()
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
