defmodule DayEight do
  def run() do
    input =
      "day_8_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    antenna_coordinates = get_coordinates_of_antennas(input)

    antinode_coordinates =
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

    antinode_coordinates
    |> Enum.concat(antenna_coordinates)
    |> Enum.uniq()
    |> Enum.count()
    |> IO.inspect()
  end

  defp get_nodes(list, {ox, oy}) do
    list
    |> Enum.reject(fn {_, {x, y}} -> x == 0 && y == 0 end)
    |> Enum.map(fn {{x, y}, {x_diff, y_diff}} ->
      {x1s, x2s} = ordinates_with_diff(ox, x, x_diff)
      {y1s, y2s} = ordinates_with_diff(oy, y, y_diff)
      [Enum.zip(x1s, y1s), Enum.zip(x2s, y2s)]
    end)
    |> List.flatten()
  end

  defp ordinates_with_diff(o_ordinate, ordinate, diff) when o_ordinate < ordinate do
    {populate_ordinate_list(o_ordinate, diff, :minus, []),
     populate_ordinate_list(ordinate, diff, :plus, [])}
  end

  defp ordinates_with_diff(o_ordinate, ordinate, diff) when o_ordinate > ordinate do
    {populate_ordinate_list(o_ordinate, diff, :plus, []),
     populate_ordinate_list(ordinate, diff, :minus, [])}
  end

  defp ordinates_with_diff(o_ordinate, ordinate, 0),
    do: {num_list(o_ordinate), num_list(ordinate)}

  defp populate_ordinate_list(o_ordinate, diff, :minus, list) when o_ordinate >= 0 do
    populate_ordinate_list(o_ordinate - diff, diff, :minus, list ++ [o_ordinate - diff])
  end

  defp populate_ordinate_list(o_ordinate, diff, :plus, list) when o_ordinate <= 49 do
    populate_ordinate_list(o_ordinate + diff, diff, :plus, list ++ [o_ordinate + diff])
  end

  defp populate_ordinate_list(_, _, _, list), do: list

  defp num_list(num) do
    Enum.map(0..49, fn _ -> num end)
  end

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

  defp get_coordinates_of_antennas(input) do
    for x <- 0..49 do
      for y <- 0..49 do
        if get_cell(input, {x, y}) != "." do
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
