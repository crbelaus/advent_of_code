defmodule AoC.Year2023.Day03 do
  def solve_part_1(input) do
    number_coordinates = number_coordinates(input)

    # Filter the numbers that are adjacent to a symbol in the previous, current or next line
    relevant_numbers =
      Enum.filter(number_coordinates, fn {line, {col_start, col_end}} ->
        line
        |> adjacent_positions(col_start, col_end)
        |> Enum.any?(&is_symbol?(input, &1))
      end)

    # Sum all the numbers that are adjacent to a symbol
    Enum.reduce(relevant_numbers, 0, fn coordinates, acc ->
      acc + extract_number(input, coordinates)
    end)
  end

  def solve_part_2(input) do
    number_coordinates = number_coordinates(input)

    # Get the coordinates for all possible gears (*) symbols
    possible_gears =
      for {line_content, line} <- Enum.with_index(input),
          matches <- Regex.scan(~r/\*/, line_content, return: :index),
          {col, 1} <- matches do
        {line, col}
      end

    # For each possible gear get the adjacent numbers. If there are exactly two adjacent numbers
    # calculate their power (multiply them) and add it to the global count.
    Enum.reduce(possible_gears, 0, fn {line, col}, acc ->
      adjacent_positions = adjacent_positions(line, col, col)

      adjacent_numbers =
        Enum.flat_map(adjacent_positions, fn {x, y} ->
          Enum.filter(number_coordinates, fn {line, {from, to}} ->
            line == y && from <= x && to >= x
          end)
        end)
        |> Enum.uniq()

      if Enum.count(adjacent_numbers) == 2 do
        power =
          adjacent_numbers
          |> Enum.map(&extract_number(input, &1))
          |> Enum.reduce(1, &Kernel.*/2)

        acc + power
      else
        acc
      end
    end)
  end

  # Create list with the number coordinates for each line such as {line, {col_start, col_end}}
  defp number_coordinates(input) do
    for {line_content, line_num} <- Enum.with_index(input),
        matches <- Regex.scan(~r/\d+/, line_content, return: :index),
        {col, length} <- matches do
      {line_num, {col, col + length - 1}}
    end
  end

  # Calculate every adjacent coordinate for the given line and range
  defp adjacent_positions(line, col_start, col_end) do
    Enum.flat_map((line - 1)..(line + 1), fn y ->
      Enum.flat_map((col_start - 1)..(col_end + 1), fn x ->
        [{x, y}]
      end)
    end)
  end

  # Check wether the character in the given coordinates is a symbol
  defp is_symbol?(input, {x, y}) do
    if line = Enum.at(input, y) do
      # Characters that are not a dot or a number.
      if string = String.at(line, x), do: String.match?(string, ~r/[^.\d]/)
    end
  end

  # Extract the number in the given coordinates
  defp extract_number(input, {line, {from, to}}) do
    input
    |> Enum.at(line)
    |> String.slice(from, to - from + 1)
    |> String.to_integer()
  end
end

# input =
#   String.split(
#     """
#     467..114..
#     ...*......
#     ..35..633.
#     ......#...
#     617*......
#     .....+.58.
#     ..592.....
#     ......755.
#     ...$.*....
#     .664.598..
#     """,
#     "\n",
#     trim: true
#   )

input = AoC.input("2023", "03")

input
|> AoC.Year2023.Day03.solve_part_1()
|> IO.inspect(label: "Part 1")

input
|> AoC.Year2023.Day03.solve_part_2()
|> IO.inspect(label: "Part 2")
