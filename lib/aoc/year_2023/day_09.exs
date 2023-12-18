defmodule AoC.Year2023.Day09 do
  def solve_part_1(input) do
    histories =
      Enum.map(input, fn line ->
        line |> String.split(" ") |> Enum.map(&String.to_integer/1)
      end)

    histories
    |> Enum.map(&extrapolate_1/1)
    |> Enum.sum()
  end

  def solve_part_2(input) do
    histories =
      Enum.map(input, fn line ->
        line |> String.split(" ") |> Enum.map(&String.to_integer/1)
      end)

    histories
    |> Enum.map(&extrapolate_2/1)
    |> Enum.sum()
  end

  def extrapolate_1(nums) do
    diffs = differencies(nums)

    if Enum.all?(diffs, &(&1 == 0)),
      do: List.last(nums),
      else: List.last(nums) + extrapolate_1(diffs)
  end

  def extrapolate_2(nums) do
    diffs = differencies(nums)

    if Enum.all?(diffs, &(&1 == 0)),
      do: List.first(nums),
      else: List.first(nums) - extrapolate_2(diffs)
  end

  defp differencies(nums) do
    # Create overlapping pairs
    # [1, 2, 3] results in [1, 2] and [2, 3]
    pairs = Enum.chunk_every(nums, 2, 1, :discard)

    Enum.map(pairs, fn [a, b] -> b - a end)
  end
end

input =
  String.split(
    """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """,
    "\n",
    trim: true
  )

input = AoC.input("2023", "09")

input
|> AoC.Year2023.Day09.solve_part_1()
|> IO.inspect(label: "Part 1")

input
|> AoC.Year2023.Day09.solve_part_2()
|> IO.inspect(label: "Part 2")
