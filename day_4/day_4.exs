defmodule DayFour do
  @size 140

  def run() do
    input =
      "day_4_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

    horizontal_count = horizontal_count(input)
    IO.inspect(horizontal_count, label: "Horizontal Count")

    vertical_count = vertical_count(input)
    IO.inspect(vertical_count, label: "Vertical Count")

    diagonal_count = diagonal_count(input)
    IO.inspect(diagonal_count, label: "Diagonal Count normal")

    reverse_diagonal_input =
      input
      |> Enum.map(&String.reverse/1)
      |> diagonal_count()

    IO.inspect(reverse_diagonal_input, label: "Diagonal Count reverse")

    total = horizontal_count + vertical_count + diagonal_count + reverse_diagonal_input
    IO.inspect(total, label: "Total")
  end

  defp diagonal_count(input) do
    list =
      input
      |> Enum.map(&String.graphemes/1)

    for row <- 0..(@size - 4),
        col <- 0..(@size - 4) do
      start =
        list
        |> Enum.at(row)
        |> Enum.at(col)

      second =
        list
        |> Enum.at(row + 1)
        |> Enum.at(col + 1)

      third =
        list
        |> Enum.at(row + 2)
        |> Enum.at(col + 2)

      fourth =
        list
        |> Enum.at(row + 3)
        |> Enum.at(col + 3)

      word = start <> second <> third <> fourth

      f = word |> get_line_count("XMAS")
      b = word |> get_line_count("SAMX")

      f + b
    end
    |> Enum.sum()
    |> IO.inspect()
  end

  defp horizontal_count(input) do
    horizontal_count_forward = horizontal_count(input, "XMAS")
    horizontal_count_backward = horizontal_count(input, "SAMX")

    horizontal_count_forward + horizontal_count_backward
  end

  defp horizontal_count(input, word) do
    input
    |> Enum.map(fn line ->
      get_line_count(line, word)
    end)
    |> Enum.sum()
  end

  defp get_line_count(line, word) do
    line
    |> String.replace(word, "+")
    |> String.graphemes()
    |> Enum.count(&(&1 == "+"))
  end

  defp vertical_count(input) do
    input
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(fn line ->
      line
      |> Tuple.to_list()
      |> Enum.join()
    end)
    |> horizontal_count()
  end
end

DayFour.run()
