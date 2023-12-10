available_cubes = %{"red" => 12, "green" => 13, "blue" => 14}

# Return a map in the shape of `available_cubes`
normalize_colors = fn cube_set ->
  cube_set
  |> String.split(", ")
  |> Map.new(fn cubes_by_color ->
    [num, color] = String.split(cubes_by_color, " ")
    {color, String.to_integer(num)}
  end)
end

input = AdventOfCode.input("2023", "02")

result =
  for {line, index} <- Enum.with_index(input, 1), reduce: 0 do
    acc ->
      [_, game] = String.split(line, ": ")
      sets = String.split(game, "; ")

      game_possible? =
        Enum.all?(sets, fn set ->
          set
          |> normalize_colors.()
          |> Enum.all?(fn {color, num} -> num <= available_cubes[color] end)
        end)

      if game_possible?, do: acc + index, else: acc
  end

IO.puts(result)
