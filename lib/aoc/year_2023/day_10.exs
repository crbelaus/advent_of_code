defmodule AoC.Year2023.Day10 do
  def solve_part_1(input) do
    navigation_map = navigation_map(input)

    {start, directions} =
      Enum.find(navigation_map, fn {_coord, navigations} -> map_size(navigations) == 4 end)

    directions
    |> Map.keys()
    |> Enum.map(&traverse(start, &1, navigation_map))
    |> Enum.map(&Enum.reverse/1)
    |> Enum.filter(&Enum.any?/1)
    |> Enum.zip()
    |> Enum.reduce_while(0, fn {coord_1, coord_2}, distance ->
      cond do
        coord_1 == start || coord_2 == start -> {:cont, distance + 1}
        coord_1 == coord_2 -> {:halt, distance}
        coord_1 != coord_2 -> {:cont, distance + 1}
      end
    end)
  end

  defp traverse(current_coord, dir, navigation_map, navigated \\ []) do
    if current_coord in navigated do
      navigated
    else
      case get_in(navigation_map, [current_coord, dir]) do
        {next_coord, next_dir} ->
          traverse(next_coord, next_dir, navigation_map, [current_coord | navigated])

        nil ->
          []
      end
    end
  end

  # Generate a map of directions that contains the pipe coordinate and the destination coordinate
  # based on the source coordinate. The start pipe is also mapped.
  defp navigation_map(input) do
    for {line_contents, line} <- Enum.with_index(input),
        {pipe, col} <- line_contents |> String.graphemes() |> Enum.with_index(),
        reduce: %{} do
      navigation_map ->
        directions =
          case pipe do
            "|" ->
              %{"N" => {{line - 1, col}, "N"}, "S" => {{line + 1, col}, "S"}}

            "-" ->
              %{"E" => {{line, col + 1}, "E"}, "W" => {{line, col - 1}, "W"}}

            "L" ->
              %{"S" => {{line, col + 1}, "E"}, "W" => {{line - 1, col}, "N"}}

            "J" ->
              %{"E" => {{line - 1, col}, "N"}, "S" => {{line, col - 1}, "W"}}

            "7" ->
              %{"E" => {{line + 1, col}, "S"}, "N" => {{line, col - 1}, "W"}}

            "F" ->
              %{"N" => {{line, col + 1}, "E"}, "W" => {{line + 1, col}, "S"}}

            "." ->
              :dot

            "S" ->
              %{
                "N" => {{line - 1, col}, "N"},
                "S" => {{line + 1, col}, "S"},
                "E" => {{line, col + 1}, "E"},
                "W" => {{line, col - 1}, "W"}
              }
          end

        case directions do
          :dot -> navigation_map
          navigations -> Map.put(navigation_map, {line, col}, navigations)
        end
    end
  end
end

# Farthest point is 4 steps away
input =
  String.split(
    """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """,
    "\n",
    trim: true
  )

# Farthest point is 8 steps away
input =
  String.split(
    """
    .....
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """,
    "\n",
    trim: true
  )

input = AoC.input("2023", "10")

input
|> AoC.Year2023.Day10.solve_part_1()
|> IO.inspect(label: "Part 1")

# input
# |> AoC.Year2023.Day09.solve_part_2()
# |> IO.inspect(label: "Part 2")
