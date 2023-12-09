defmodule AoC do
  def extract_digits(string, acc \\ []) do
    case string do
      <<?1, rest::binary>> -> extract_digits(rest, acc ++ [1])
      <<?2, rest::binary>> -> extract_digits(rest, acc ++ [2])
      <<?3, rest::binary>> -> extract_digits(rest, acc ++ [3])
      <<?4, rest::binary>> -> extract_digits(rest, acc ++ [4])
      <<?5, rest::binary>> -> extract_digits(rest, acc ++ [5])
      <<?6, rest::binary>> -> extract_digits(rest, acc ++ [6])
      <<?7, rest::binary>> -> extract_digits(rest, acc ++ [7])
      <<?8, rest::binary>> -> extract_digits(rest, acc ++ [8])
      <<?9, rest::binary>> -> extract_digits(rest, acc ++ [9])
      <<_head, rest::binary>> -> extract_digits(rest, acc)
      "" -> acc
    end
  end
end

result =
  for line <- AdventOfCode.input("2023", "01"), reduce: 0 do
    acc ->
      digits = AoC.extract_digits(line)

      if Enum.any?(digits),
        do: acc + List.first(digits) * 10 + List.last(digits),
        else: acc
  end

IO.puts(result)
