defmodule AoC do
  def extract_digits(string, acc \\ []) do
    case string do
      <<"one", rest::binary>> -> extract_digits("e" <> rest, acc ++ [1])
      <<"two", rest::binary>> -> extract_digits("o" <> rest, acc ++ [2])
      <<"three", rest::binary>> -> extract_digits("e" <> rest, acc ++ [3])
      <<"four", rest::binary>> -> extract_digits("r" <> rest, acc ++ [4])
      <<"five", rest::binary>> -> extract_digits("e" <> rest, acc ++ [5])
      <<"six", rest::binary>> -> extract_digits("x" <> rest, acc ++ [6])
      <<"seven", rest::binary>> -> extract_digits("n" <> rest, acc ++ [7])
      <<"eight", rest::binary>> -> extract_digits("t" <> rest, acc ++ [8])
      <<"nine", rest::binary>> -> extract_digits("e" <> rest, acc ++ [9])
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
