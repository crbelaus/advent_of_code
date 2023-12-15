defmodule AoC.Year2023.Day05 do
  @mapping_names [
    "seed-to-soil",
    "soil-to-fertilizer",
    "fertilizer-to-water",
    "water-to-light",
    "light-to-temperature",
    "temperature-to-humidity",
    "humidity-to-location"
  ]

  def solve_part_1(input) do
    ["seeds: " <> raw_seeds | raw_mappings] = input

    mappings = build_mappings(raw_mappings)

    raw_seeds
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&get_location(&1, mappings))
    |> Enum.min()
  end

  def solve_part_2(input) do
    ["seeds: " <> raw_seeds | raw_mappings] = input

    mappings = build_mappings(raw_mappings)

    seeds =
      raw_seeds
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [range_start, range_length] ->
        range_start..(range_start + range_length - 1)
      end)
      |> Enum.reduce([], fn seed_range, seeds ->
        new_seed_ranges =
          Enum.reduce(seeds, [seed_range], fn existing_seed, new_seed ->
            cond do
              new_seed.last < existing_seed.first || new_seed.first > existing_seed.last ->
                [new_seed]
            end
          end)

        seeds ++ new_seed_ranges
      end)

    # |> Enum.reduce([], fn range, acc ->
    #   unique_subranges =
    #     for acc_range <- acc do
    #       cond do
    #         range.last < acc_range.first || range.first > acc_range.last ->
    #           [range]

    #         range.first >= acc_range.first && range.last <= acc_range.last ->
    #           []

    #         range.first < acc_range.first && range.last > acc_range.last ->
    #           [range.first..(acc_range.first - 1), (range.last + 1)..acc_range.last]

    #         range.first >= acc_range.first && range.last > acc_range.last ->
    #           [(acc_range.last + 1)..range.last]

    #         range.first < acc_range.first && range.last <= acc_range.last ->
    #           [range.first..(acc_range.first - 1)]
    #       end
    #     end

    #   dbg(unique_subranges)

    #   acc ++ List.flatten(unique_subranges)
    # end)

    dbg(seeds)

    seeds
    |> Enum.flat_map(fn seed_range -> Enum.map(seed_range, &get_location(&1, mappings)) end)
    |> Enum.min()
  end

  defp build_mappings(raw_mappings) do
    initial_mappings = Map.new(@mapping_names, &{&1, []})

    {_, mappings} =
      for raw_mapping <- raw_mappings, reduce: {nil, initial_mappings} do
        {current_mapping_name, mappings} ->
          case String.split(raw_mapping, " ", trim: true) do
            [new_mapping_name, "map:"] ->
              {new_mapping_name, mappings}

            [dest_range_start, source_range_start, range_length] ->
              dest_range_start = String.to_integer(dest_range_start)
              source_range_start = String.to_integer(source_range_start)
              range_length = String.to_integer(range_length) - 1

              source_range = source_range_start..(source_range_start + range_length)

              updated_mappings =
                Map.update!(mappings, current_mapping_name, fn prev_items ->
                  prev_items ++ [{source_range, dest_range_start}]
                end)

              {current_mapping_name, updated_mappings}
          end
      end

    mappings
  end

  defp get_location(seed, mappings) do
    for mapping <- @mapping_names, reduce: seed do
      source ->
        case Enum.find(mappings[mapping], &(source in elem(&1, 0))) do
          {%Range{first: first}, base_dest} -> base_dest + source - first
          _not_found -> source
        end
    end
  end
end

input =
  String.split(
    """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """,
    "\n",
    trim: true
  )

# input = AoC.input("2023", "05")

# input
# |> AoC.Year2023.Day05.solve_part_1()
# |> IO.inspect(label: "Part 1")

input
|> AoC.Year2023.Day05.solve_part_2()
|> IO.inspect(label: "Part 2")
