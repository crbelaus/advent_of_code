defmodule AoC.Year2023.Day11 do
  def solve_part_1(input) do
    # Transform each row into a list of symbols
    input = Enum.map(input, &String.graphemes/1)

    rows_without_galaxy = rows_without_galaxy(input)
    cols_without_galaxy = cols_without_galaxy(input)
    galaxies = galaxies(input)

    for {galaxy_a, i} <- Enum.with_index(galaxies),
        galaxy_b <- Enum.slice(galaxies, i + 1, Enum.count(galaxies)),
        galaxy_a != galaxy_b,
        reduce: 0 do
      acc ->
        rows_inbetween = elem(galaxy_a, 0)..elem(galaxy_b, 0)
        cols_inbetween = elem(galaxy_a, 1)..elem(galaxy_b, 1)
        # If we step on a row or col that doesn't have galaxies it must be duplicated. We discount
        # the current row or col as it has been already counted
        expand_rows = rows_without_galaxy |> Enum.filter(&(&1 in rows_inbetween)) |> Enum.count()
        expand_cols = cols_without_galaxy |> Enum.filter(&(&1 in cols_inbetween)) |> Enum.count()
        # We want to remove the source galaxy itself, this is why we remove 1 distance
        horizontal_distance = Enum.count(cols_inbetween) - 1 + expand_rows
        vertical_distance = Enum.count(rows_inbetween) - 1 + expand_cols

        acc + horizontal_distance + vertical_distance
    end
  end

  def solve_part_2(input) do
    # Transform each row into a list of symbols
    input = Enum.map(input, &String.graphemes/1)

    rows_without_galaxy = rows_without_galaxy(input)
    cols_without_galaxy = cols_without_galaxy(input)
    galaxies = galaxies(input)

    for {galaxy_a, i} <- Enum.with_index(galaxies),
        galaxy_b <- Enum.slice(galaxies, i + 1, Enum.count(galaxies)),
        galaxy_a != galaxy_b,
        reduce: 0 do
      acc ->
        rows_inbetween = elem(galaxy_a, 0)..elem(galaxy_b, 0)
        cols_inbetween = elem(galaxy_a, 1)..elem(galaxy_b, 1)
        # If we step on a row or col that doesn't have galaxies it must be replaced with 1.000.000
        # empty rows or cols. We discount the current row or col as it has been already counted.
        expand_rows =
          rows_without_galaxy
          |> Enum.filter(&(&1 in rows_inbetween))
          |> Enum.count()
          |> Kernel.*(1_000_000 - 1)

        expand_cols =
          cols_without_galaxy
          |> Enum.filter(&(&1 in cols_inbetween))
          |> Enum.count()
          |> Kernel.*(1_000_000 - 1)

        # We want to remove the source galaxy itself, this is why we remove 1 distance
        horizontal_distance = Enum.count(cols_inbetween) - 1 + expand_rows
        vertical_distance = Enum.count(rows_inbetween) - 1 + expand_cols

        acc + horizontal_distance + vertical_distance
    end
  end

  defp rows_without_galaxy(input) do
    input
    |> Enum.with_index()
    |> Enum.reject(fn {row, _i} -> Enum.any?(row, &is_galaxy?/1) end)
    |> Enum.map(fn {_row, i} -> i end)
  end

  defp cols_without_galaxy(input) do
    num_cols = input |> List.first() |> Enum.count()

    Enum.reject(0..(num_cols - 1), fn col ->
      input
      |> Enum.map(&Enum.at(&1, col))
      |> Enum.any?(&is_galaxy?/1)
    end)
  end

  defp is_galaxy?(symbol), do: symbol == "#"

  defp galaxies(input) do
    num_cols = input |> List.first() |> Enum.count()
    num_rows = Enum.count(input)

    for row <- 0..(num_rows - 1), col <- 0..(num_cols - 1), reduce: [] do
      galaxies ->
        symbol = input |> Enum.at(row) |> Enum.at(col)

        if is_galaxy?(symbol),
          do: [{row, col} | galaxies],
          else: galaxies
    end
  end
end

input =
  String.split(
    """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """,
    "\n",
    trim: true
  )

input = AoC.input("2023", "11")

input
|> AoC.Year2023.Day11.solve_part_1()
|> IO.inspect(label: "Part 1")

input
|> AoC.Year2023.Day11.solve_part_2()
|> IO.inspect(label: "Part 2")
