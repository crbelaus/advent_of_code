defmodule AoC.Year2023.Day02 do
  def solve_part_1(input) do
    input
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {line, index}, acc ->
      game_possible? =
        line
        |> extract_cube_sets()
        |> Enum.all?(&set_possible?/1)

      if game_possible?, do: acc + index, else: acc
    end)
  end

  defp set_possible?(cube_set) do
    cube_set
    |> normalize_colors()
    |> Enum.all?(fn {color, num} -> num <= available_cubes(color) end)
  end

  defp available_cubes("blue"), do: 14
  defp available_cubes("green"), do: 13
  defp available_cubes("red"), do: 12

  def solve_part_2(input) do
    Enum.reduce(input, 0, fn line, acc ->
      cube_sets = extract_cube_sets(line)

      # For each set we get a map of colors such as %{"red" => 2, "blue" => 5} and so on. Then, for
      # each of those colors we chech if the current number of cubes is greater than the current
      # viable minimum that we have recorded.
      # If it is greater than the minimum we update the minimum and otherwise we keep the current
      # minimum.
      minimum_viable_cube_set =
        Enum.reduce(cube_sets, %{}, fn cube_set, minimum_viable_cube_set ->
          normalized_colors = normalize_colors(cube_set)

          Enum.reduce(normalized_colors, minimum_viable_cube_set, fn {color, num}, acc ->
            current_minimum = acc[color] || 0

            if num > current_minimum, do: Map.put(acc, color, num), else: acc
          end)
        end)

      minimum_viable_cube_power =
        minimum_viable_cube_set
        |> Map.values()
        |> Enum.reduce(1, &Kernel.*/2)

      acc + minimum_viable_cube_power
    end)
  end

  defp extract_cube_sets(line) do
    [_, game] = String.split(line, ": ")
    String.split(game, "; ")
  end

  defp normalize_colors(cube_set) do
    cube_set
    |> String.split(", ")
    |> Map.new(fn cubes_by_color ->
      [num, color] = String.split(cubes_by_color, " ")
      {color, String.to_integer(num)}
    end)
  end
end

AoC.input("2023", "02")
|> AoC.Year2023.Day02.solve_part_1()
|> IO.inspect(label: "Part 1")

AoC.input("2023", "02")
|> AoC.Year2023.Day02.solve_part_2()
|> IO.inspect(label: "Part 2")
