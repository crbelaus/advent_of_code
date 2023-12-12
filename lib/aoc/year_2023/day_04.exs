defmodule AoC.Year2023.Day04 do
  def solve_part_1(input) do
    for card <- input, reduce: 0 do
      score ->
        {winning_numbers, numbers_we_have} = extract_numbers(card)
        matching_numbers = MapSet.intersection(winning_numbers, numbers_we_have)

        card_score =
          Enum.reduce(0..Enum.count(matching_numbers), 0, fn
            0, acc -> acc
            1, acc -> acc + 1
            _, acc -> acc * 2
          end)

        score + card_score
    end
  end

  defp extract_numbers(card) do
    [_, x] = String.split(card, ": ")
    [winning_numbers, numbers_we_have] = String.split(x, " | ", trim: true)

    {build_number_set(winning_numbers), build_number_set(numbers_we_have)}
  end

  defp build_number_set(numbers_string) do
    numbers_string
    |> String.split(" ", trim: true)
    |> MapSet.new()
  end

  def solve_part_2(input) do
    matching_numbers =
      for {card, index} <- Enum.with_index(input), into: %{} do
        {winning_numbers, numbers_we_have} = extract_numbers(card)
        matching_numbers = MapSet.intersection(winning_numbers, numbers_we_have)

        {index, Enum.count(matching_numbers)}
      end

    initial_copies = for index <- 0..(Enum.count(input) - 1), into: %{}, do: {index, 1}

    copies =
      for {i, matching_nums} <- Enum.sort_by(matching_numbers, &elem(&1, 0)),
          matching_num <- 1..matching_nums,
          matching_nums > 0,
          reduce: initial_copies do
        copies ->
          if Map.has_key?(copies, i + matching_num),
            do: Map.update!(copies, i + matching_num, &(&1 + copies[i])),
            else: copies
      end

    copies |> Map.values() |> Enum.sum()
  end
end

# input =
#   String.split(
#     """
#     Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
#     Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
#     Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
#     Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
#     Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
#     Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
#     """,
#     "\n",
#     trim: true
#   )

input = AoC.input("2023", "04")

input
|> AoC.Year2023.Day04.solve_part_1()
|> IO.inspect(label: "Part 1")

input
|> AoC.Year2023.Day04.solve_part_2()
|> IO.inspect(label: "Part 2")
