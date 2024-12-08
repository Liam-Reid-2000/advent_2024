defmodule DayEight do
  def run() do
    input =
      "day_8_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    for x <- 0..49 do
      for y <- 0..49 do
        char = get_cell(input, {x, y})

        if char == "." do
          []
        else
          matching =
            input
            |> get_matching_coordinates(char)

          diffs =
            get_diffs(matching, {x, y})

          matching
          |> Enum.zip(diffs)
          |> get_nodes({x, y})
        end
      end
    end
    |> List.flatten()
    |> Enum.reject(fn {x, y} -> is_nil(x) or is_nil(y) or x < 0 or y < 0 or x > 49 or y > 49 end)
    |> Enum.uniq()
    |> Enum.count()
    |> IO.inspect()
  end

  defp get_nodes(list, {ox, oy}) do
    list
    |> Enum.reject(fn {_, {x, y}} -> x == 0 && y == 0 end)
    |> Enum.map(fn {{x, y}, {x_diff, y_diff}} ->
      {x1, x2} = ordinates_with_diff(ox, x, x_diff)
      {y1, y2} = ordinates_with_diff(oy, y, y_diff)
      [{x1, y1}, {x2, y2}]
    end)
    |> List.flatten()
  end

  defp ordinates_with_diff(o_ordinate, ordinate, diff) when o_ordinate < ordinate do
    {o_ordinate - diff, ordinate + diff}
  end

  defp ordinates_with_diff(o_ordinate, ordinate, diff) when o_ordinate > ordinate do
    {o_ordinate + diff, ordinate - diff}
  end

  defp ordinates_with_diff(_o_ordinate, _ordinate, _diff), do: {0, 0}

  defp get_matching_coordinates(input, char) do
    for x <- 0..49 do
      for y <- 0..49 do
        if get_cell(input, {x, y}) == char do
          {x, y}
        end
      end
    end
    |> List.flatten()
    |> Enum.filter(&(&1 != nil))
  end

  defp get_diffs(matching, {ox, oy}) do
    Enum.map(matching, fn {x, y} ->
      x_diff = abs(x - ox)
      y_diff = abs(y - oy)
      {x_diff, y_diff}
    end)
  end

  defp get_cell(map, {x, y}) do
    map
    |> Enum.at(y)
    |> Enum.at(x)
  end
end

DayEight.run()
