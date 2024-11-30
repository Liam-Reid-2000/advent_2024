defmodule DayOne do
  def run() do
    "day_1_input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&get_line_sums/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp get_line_sums(line) do
    line_nums =
      line
      |> String.graphemes()
      |> Enum.map(&get_num/1)
      |> Enum.filter(& &1)

    "#{List.first(line_nums)}#{List.last(line_nums)}" |> get_num()
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, _} -> num
      _ -> nil
    end
  end
end

DayOne.run()
