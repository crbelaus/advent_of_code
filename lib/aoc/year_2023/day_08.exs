defmodule AoC.Year2023.Day08 do
  def solve_part_1(input) do
    instructions = instructions(input)
    nodes = nodes(input)

    navigated_nodes =
      Enum.reduce_while(instructions, ["AAA"], fn instruction, navigated_nodes ->
        current_node = List.first(navigated_nodes)

        case nodes[current_node][instruction] do
          "ZZZ" -> {:halt, navigated_nodes}
          new_node -> {:cont, [new_node | navigated_nodes]}
        end
      end)

    Enum.count(navigated_nodes)
  end

  # Generates an infinite stream of instructions that we can iterate over and over again.
  defp instructions([raw_instructions | _raw_nodes]) do
    raw_instructions |> String.graphemes() |> Stream.cycle()
  end

  # Generates a map of nodes such as %{"AAA" => %{"L" => "BBB", "R" => "CCC'}}
  defp nodes([_raw_instructions | raw_nodes]) do
    for raw_node <- raw_nodes, reduce: %{} do
      nodes ->
        [[source_node], [left_node], [right_node]] = Regex.scan(~r/[A-Z]{3}/, raw_node)
        Map.put(nodes, source_node, %{"L" => left_node, "R" => right_node})
    end
  end

  def solve_part_2(input) do
    instructions = instructions(input)
    nodes = nodes(input)

    path_lengths =
      for initial_node <- nodes |> Map.keys() |> Enum.filter(&String.ends_with?(&1, "A")) do
        navigated_nodes =
          Enum.reduce_while(instructions, [initial_node], fn instruction, navigated_nodes ->
            current_node = List.first(navigated_nodes)
            next_node = nodes[current_node][instruction]

            if String.ends_with?(next_node, "Z"),
              do: {:halt, navigated_nodes},
              else: {:cont, [next_node | navigated_nodes]}
          end)

        Enum.count(navigated_nodes)
      end

    # The list contains the path lengths from each source to the corresponding target.
    # Knowing this, the shortest common path that satisfaces all sources is the least common
    # multiple of those lengths.
    Enum.reduce(path_lengths, &Math.lcm/2)
  end
end

# input =
#   String.split(
#     """
#     RL

#     AAA = (BBB, CCC)
#     BBB = (DDD, EEE)
#     CCC = (ZZZ, GGG)
#     DDD = (DDD, DDD)
#     EEE = (EEE, EEE)
#     GGG = (GGG, GGG)
#     ZZZ = (ZZZ, ZZZ)
#     """,
#     "\n",
#     trim: true
#   )

# input =
#   String.split(
#     """
#     LLR

#     AAA = (BBB, BBB)
#     BBB = (AAA, ZZZ)
#     ZZZ = (ZZZ, ZZZ)
#     """,
#     "\n",
#     trim: true
#   )

input = AoC.input("2023", "08")

input
|> AoC.Year2023.Day08.solve_part_1()
|> IO.inspect(label: "Part 1")

input
|> AoC.Year2023.Day08.solve_part_2()
|> IO.inspect(label: "Part 2")

# 13_385_272_668_829
# 13_385_272_668_829
