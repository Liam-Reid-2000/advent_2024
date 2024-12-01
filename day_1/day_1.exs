defmodule DayOne do
  def run() do
    input_list =
      "day_1_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "   "))

    populated_lists =
      populate_lists([], [], input_list)

    part_1(populated_lists)
    part_2(populated_lists)
  end

  def part_1({list_1, list_2}) do
    sorted_1 = list_1 |> Enum.sort()
    sorted_2 = list_2 |> Enum.sort()

    sorted_1
    |> Enum.zip(sorted_2)
    |> Enum.map(&get_line_diff/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2({list_1, list_2}) do
    list_1
    |> Enum.map(&(&1 * Enum.count(list_2, fn x -> &1 == x end)))
    |> Enum.sum()
    |> IO.inspect()
  end

  defp get_line_diff({num_1, num_2}) when num_1 > num_2 do
    num_1 - num_2
  end

  defp get_line_diff({num_1, num_2}) do
    num_2 - num_1
  end

  defp populate_lists(list_1, list_2, []), do: {list_1, list_2}
  defp populate_lists(list_1, list_2, input_list) do
    [h | t] = input_list
    [num_1, num_2] = h
    list_1 = [get_num(num_1) | list_1]
    list_2 = [get_num(num_2) | list_2]

    populate_lists(list_1, list_2, t)
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, _} -> num
      _ -> nil
    end
  end
end

DayOne.run()
