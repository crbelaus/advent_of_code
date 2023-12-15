defmodule AoC.Year2023.Day06 do
  def solve_part_1([times, distances]) do
    times = times |> digits() |> Enum.map(&String.to_integer/1)
    distances = distances |> digits() |> Enum.map(&String.to_integer/1)

    for {allowed_time, best_distance} <- Enum.zip(times, distances), reduce: 1 do
      winning_plays_count ->
        winning_plays =
          Enum.filter(0..(allowed_time - 1), fn speed ->
            # Accelerates 1 speed unit pear each time unit, so 2 speed units mean 2 time units spent
            remaining_time = allowed_time - speed
            distance = remaining_time * speed

            distance > best_distance
          end)

        winning_plays_count * Enum.count(winning_plays)
    end
  end

  defp digits(line) do
    ~r/\d+/ |> Regex.scan(line) |> List.flatten()
  end

  def solve_part_2([times, distances]) do
    allowed_time = times |> digits() |> Enum.join() |> String.to_integer()
    best_distance = distances |> digits() |> Enum.join() |> String.to_integer()

    winning_plays =
      Enum.filter(0..(allowed_time - 1), fn speed ->
        # Accelerates 1 speed unit pear each time unit. So 2 speed units mean 2 time units.
        remaining_time = allowed_time - speed
        distance = remaining_time * speed

        distance > best_distance
      end)

    Enum.count(winning_plays)
  end
end

input =
  String.split(
    """
    Time:      7  15   30
    Distance:  9  40  200
    """,
    "\n",
    trim: true
  )

input = AoC.input("2023", "06")

input
|> AoC.Year2023.Day06.solve_part_1()
|> IO.inspect(label: "Part 1")

input
|> AoC.Year2023.Day06.solve_part_2()
|> IO.inspect(label: "Part 2")
