defmodule AoC.Year2023.Day01 do
  def solve(input, extract_digits_fun) do
    Enum.reduce(input, 0, fn line, acc ->
      digits = extract_digits_fun.(line)

      if Enum.any?(digits),
        do: acc + List.first(digits) * 10 + List.last(digits),
        else: acc
    end)
  end

  def extract_digits_part_1(string, acc \\ []) do
    case string do
      <<?1, rest::binary>> -> extract_digits_part_1(rest, acc ++ [1])
      <<?2, rest::binary>> -> extract_digits_part_1(rest, acc ++ [2])
      <<?3, rest::binary>> -> extract_digits_part_1(rest, acc ++ [3])
      <<?4, rest::binary>> -> extract_digits_part_1(rest, acc ++ [4])
      <<?5, rest::binary>> -> extract_digits_part_1(rest, acc ++ [5])
      <<?6, rest::binary>> -> extract_digits_part_1(rest, acc ++ [6])
      <<?7, rest::binary>> -> extract_digits_part_1(rest, acc ++ [7])
      <<?8, rest::binary>> -> extract_digits_part_1(rest, acc ++ [8])
      <<?9, rest::binary>> -> extract_digits_part_1(rest, acc ++ [9])
      <<_head, rest::binary>> -> extract_digits_part_1(rest, acc)
      "" -> acc
    end
  end

  # Just like part 1 but now there may be digits as words and overlapped such as
  # "oneight" which should return [1, 8].
  def extract_digits_part_2(string, acc \\ []) do
    case string do
      <<"one", rest::binary>> -> extract_digits_part_2("e" <> rest, acc ++ [1])
      <<"two", rest::binary>> -> extract_digits_part_2("o" <> rest, acc ++ [2])
      <<"three", rest::binary>> -> extract_digits_part_2("e" <> rest, acc ++ [3])
      <<"four", rest::binary>> -> extract_digits_part_2("r" <> rest, acc ++ [4])
      <<"five", rest::binary>> -> extract_digits_part_2("e" <> rest, acc ++ [5])
      <<"six", rest::binary>> -> extract_digits_part_2("x" <> rest, acc ++ [6])
      <<"seven", rest::binary>> -> extract_digits_part_2("n" <> rest, acc ++ [7])
      <<"eight", rest::binary>> -> extract_digits_part_2("t" <> rest, acc ++ [8])
      <<"nine", rest::binary>> -> extract_digits_part_2("e" <> rest, acc ++ [9])
      <<?1, rest::binary>> -> extract_digits_part_2(rest, acc ++ [1])
      <<?2, rest::binary>> -> extract_digits_part_2(rest, acc ++ [2])
      <<?3, rest::binary>> -> extract_digits_part_2(rest, acc ++ [3])
      <<?4, rest::binary>> -> extract_digits_part_2(rest, acc ++ [4])
      <<?5, rest::binary>> -> extract_digits_part_2(rest, acc ++ [5])
      <<?6, rest::binary>> -> extract_digits_part_2(rest, acc ++ [6])
      <<?7, rest::binary>> -> extract_digits_part_2(rest, acc ++ [7])
      <<?8, rest::binary>> -> extract_digits_part_2(rest, acc ++ [8])
      <<?9, rest::binary>> -> extract_digits_part_2(rest, acc ++ [9])
      <<_head, rest::binary>> -> extract_digits_part_2(rest, acc)
      "" -> acc
    end
  end
end

AoC.input("2023", "01")
|> AoC.Year2023.Day01.solve(&AoC.Year2023.Day01.extract_digits_part_1/1)
|> IO.inspect(label: "Part 1")

AoC.input("2023", "01")
|> AoC.Year2023.Day01.solve(&AoC.Year2023.Day01.extract_digits_part_2/1)
|> IO.inspect(label: "Part 2")
