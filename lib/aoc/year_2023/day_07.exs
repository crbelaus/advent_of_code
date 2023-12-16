defmodule AoC.Year2023.Day07 do
  # From less to more strength (part 1)
  @cards_by_strength_1 ~w(2 3 4 5 6 7 8 9 T J Q K A)
  # From less to more strength (part 2)
  @cards_by_strength_2 ~w(J 2 3 4 5 6 7 8 9 T Q K A)

  def solve_part_1(input) do
    input
    |> Enum.map(&String.split(&1, " "))
    |> Enum.sort(&sort_by_rank_1/2)
    |> Enum.with_index(1)
    |> Enum.map(fn {[_, bid], rank} -> String.to_integer(bid) * rank end)
    |> Enum.sum()
  end

  defp sort_by_rank_1([hand_1, _bid_1], [hand_2, _bid_2]) do
    rank_1 = rank_part_1(hand_1)
    rank_2 = rank_part_1(hand_2)

    if rank_1 == rank_2,
      do: sort_by_strength(hand_1, hand_2, @cards_by_strength_1),
      else: rank_1 < rank_2
  end

  defp rank_part_1(hand) do
    # Generates a map with cards as keys and frequencies as values
    # "KTJJT" => %{"J" => 2, "K" => 1, "T" => 2}
    cards = hand |> String.graphemes() |> Enum.frequencies()

    cond do
      # Five of a kind
      Enum.find(cards, &match?({_, 5}, &1)) -> 7
      # Four of a kind
      Enum.find(cards, &match?({_, 4}, &1)) -> 6
      # Full house
      Enum.find(cards, &match?({_, 3}, &1)) && Enum.find(cards, &match?({_, 2}, &1)) -> 5
      # Three of a kind
      Enum.find(cards, &match?({_, 3}, &1)) -> 4
      # Two pair
      Enum.count(cards, &match?({_, 2}, &1)) == 2 -> 3
      # One pair
      Enum.count(cards, &match?({_, 2}, &1)) == 1 -> 2
      # High card
      true -> 1
    end
  end

  def solve_part_2(input) do
    input
    |> Enum.map(&String.split(&1, " "))
    |> Enum.sort(&sort_by_rank_2/2)
    |> Enum.with_index(1)
    |> Enum.map(fn {[_, bid], rank} -> String.to_integer(bid) * rank end)
    |> Enum.sum()
  end

  defp sort_by_rank_2([hand_1, _bid_1], [hand_2, _bid_2]) do
    rank_1 = rank_part_2(hand_1)
    rank_2 = rank_part_2(hand_2)

    if rank_1 == rank_2,
      do: sort_by_strength(hand_1, hand_2, @cards_by_strength_2),
      else: rank_1 < rank_2
  end

  defp rank_part_2(hand) do
    cards = hand |> String.graphemes() |> Enum.frequencies()

    cards_without_jokers =
      case Map.pop(cards, "J", 0) do
        # If the hand does not have any joker return it as-is
        {0, _} ->
          hand

        # If the hand has all jokers return it as-is
        {5, _} ->
          hand

        # Otherwise just add the joker to the most frequent card
        {jokers_count, not_jokers} ->
          [{most_frequent_card, _} | _] = Enum.sort_by(not_jokers, &elem(&1, 1), :desc)
          jokers_applied = Map.update!(not_jokers, most_frequent_card, &(&1 + jokers_count))

          Enum.reduce(jokers_applied, "", fn {card, frequency}, hand ->
            repeated_card = for _ <- 1..frequency, into: "", do: card
            hand <> repeated_card
          end)
      end

    rank_part_1(cards_without_jokers)
  end

  defp sort_by_strength(hand_1, hand_2, strenghts) do
    cards_1 = String.graphemes(hand_1)
    cards_2 = String.graphemes(hand_2)

    pairs = Enum.zip(cards_1, cards_2)

    Enum.reduce_while(pairs, true, fn {card_1, card_2}, acc ->
      if card_1 == card_2 do
        {:cont, acc}
      else
        strength_1 = Enum.find_index(strenghts, &(&1 == card_1))
        strength_2 = Enum.find_index(strenghts, &(&1 == card_2))

        {:halt, strength_1 < strength_2}
      end
    end)
  end
end

input =
  String.split(
    """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """,
    "\n",
    trim: true
  )

input = AoC.input("2023", "07")

input
|> AoC.Year2023.Day07.solve_part_1()
|> IO.inspect(label: "Part 1")

input
|> AoC.Year2023.Day07.solve_part_2()
|> IO.inspect(label: "Part 2")
