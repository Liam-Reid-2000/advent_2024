defmodule DayFour do
  @size 140

  def run() do
    input =
      "day_4_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

    part_1(input) |> IO.inspect(label: "Part 1")
    part_2(input) |> IO.inspect(label: "Part 2")
  end

  defp part_1(input) do
    horizontal_count = horizontal_count(input)
    vertical_count = vertical_count(input)
    diagonal_count = diagonal_count(input)

    reverse_diagonal_input =
      input
      |> Enum.map(&String.reverse/1)
      |> diagonal_count()

    horizontal_count + vertical_count + diagonal_count + reverse_diagonal_input
  end

  defp part_2(input) do
    list = Enum.map(input, &String.graphemes/1)

    for row <- 0..(@size - 3),
        col <- 0..(@size - 3) do
      first = list |> Enum.at(row) |> Enum.at(col)
      second = list |> Enum.at(row + 2) |> Enum.at(col)
      third = list |> Enum.at(row + 1) |> Enum.at(col + 1)
      fourth = list |> Enum.at(row) |> Enum.at(col + 2)
      fifth = list |> Enum.at(row + 2) |> Enum.at(col + 2)

      cond do
        third != "A" -> 0
        first == "M" and second == "M" and fourth == "S" and fifth == "S" -> 1
        first == "S" and second == "S" and fourth == "M" and fifth == "M" -> 1
        first == "M" and second == "S" and fourth == "M" and fifth == "S" -> 1
        first == "S" and second == "M" and fourth == "S" and fifth == "M" -> 1
        true -> 0
      end
    end
    |> Enum.sum()
  end

  defp diagonal_count(input) do
    list = Enum.map(input, &String.graphemes/1)

    for row <- 0..(@size - 4),
        col <- 0..(@size - 4) do
      word =
        for x <- 0..3 do
          list
          |> Enum.at(row + x)
          |> Enum.at(col + x)
        end
        |> Enum.join()

      if word in ["XMAS", "SAMX"], do: 1, else: 0
    end
    |> Enum.sum()
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
