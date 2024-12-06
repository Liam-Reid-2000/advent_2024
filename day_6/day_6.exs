defmodule DaySix do
  def run() do
    input =
      "day_6_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    {x, y} = guard_index(input)

    map = mark_x(input, x, y)
    marked_map = move(map, x, y, :up)

    marked_map
    |> Enum.map(&Enum.count(&1, fn x -> x == "X" end))
    |> Enum.sum()
    |> IO.inspect()
  end

  defp guard_index(map) do
    y = Enum.find_index(map, &("^" in &1))

    x =
      map
      |> Enum.at(y)
      |> Enum.find_index(&(&1 == "^"))

    {x, y}
  end

  defp move(map, _x, _y, :halt), do: map

  defp move(map, x, y, direction) do
    cond do
      x == 0 and direction == :left ->
        move(map, x, y, :halt)

      y == 0 and direction == :up ->
        move(map, x, y, :halt)

      x == 130 and direction == :right ->
        move(map, x, y, :halt)

      y == 130 and direction == :down ->
        move(map, x, y, :halt)

      true ->
        new_pos = new_pos(x, y, direction)

        if get_cell(map, new_pos) == "#" do
          map = mark_x(map, x, y)
          direction = change_direction(direction)
          move(map, x, y, direction)
        else
          {x, y} = new_pos
          map = mark_x(map, x, y)
          move(map, x, y, direction)
        end
    end
  end

  defp change_direction(:up), do: :right
  defp change_direction(:right), do: :down
  defp change_direction(:down), do: :left
  defp change_direction(:left), do: :up

  defp new_pos(x, y, :up), do: {x, y - 1}
  defp new_pos(x, y, :down), do: {x, y + 1}
  defp new_pos(x, y, :left), do: {x - 1, y}
  defp new_pos(x, y, :right), do: {x + 1, y}

  defp get_cell(map, {x, y}) do
    map
    |> Enum.at(y)
    |> Enum.at(x)
  end

  defp mark_x(map, x, y) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, y_index} ->
      if y_index == y do
        row
        |> Enum.with_index()
        |> Enum.map(fn {cell, x_index} ->
          if x_index == x do
            "X"
          else
            cell
          end
        end)
      else
        row
      end
    end)
  end
end

DaySix.run()
