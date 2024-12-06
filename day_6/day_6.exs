defmodule DaySix do
  def run() do
    input =
      "day_6_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    # 5453
    part_1(input) |> IO.inspect(label: "Part 1")
    # 2188
    part_2(input) |> IO.inspect(label: "Part 2")
  end

  defp part_1(input) do
    {x, y} = guard_index(input)

    map = mark_x(input, x, y)
    marked_map = move(map, x, y, :up, 0)

    marked_map
    |> Enum.map(&Enum.count(&1, fn x -> x == "X" end))
    |> Enum.sum()
  end

  defp part_2(map) do
    {x, y} = guard_index(map)
    marked_map = move(map, x, y, :up, 0)

    res =
      for z <- 0..129, t <- 0..129 do
        if get_cell(marked_map, {z, t}) == "X" do
          map
          |> mark_x(z, t, "O")
          |> move(x, y, :up, 0)
          |> loop_val()
        else
          0
        end
      end
      |> Enum.sum()

    res + 1
  end

  defp loop_val(:loop), do: 1
  defp loop_val(_), do: 0

  defp guard_index(map) do
    y = Enum.find_index(map, &("^" in &1))

    x =
      map
      |> Enum.at(y)
      |> Enum.find_index(&(&1 == "^"))

    {x, y}
  end

  defp move(map, _x, _y, :halt), do: map

  defp move(map, x, y, direction, iterations \\ 0) do
    # visualise(map)
    cond do
      iterations >= 16900 ->
        :loop

      x == 0 and direction == :left ->
        move(map, x, y, :halt)

      y == 0 and direction == :up ->
        move(map, x, y, :halt)

      x == 129 and direction == :right ->
        move(map, x, y, :halt)

      y == 129 and direction == :down ->
        move(map, x, y, :halt)

      true ->
        new_pos = new_pos(x, y, direction)
        map = mark_x(map, x, y)

        if get_cell(map, new_pos) in ["#", "O"] do
          direction = change_direction(direction)
          move(map, x, y, direction, iterations)
        else
          {x, y} = new_pos
          move(map, x, y, direction, iterations + 1)
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

  defp mark_x(map, x, y, marker \\ "X") do
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, y_index} ->
      if y_index == y do
        row
        |> Enum.with_index()
        |> Enum.map(fn {cell, x_index} ->
          if x_index == x do
            marker
          else
            cell
          end
        end)
      else
        row
      end
    end)
  end

  defp visualise(map) do
    IO.inspect("##################")
    IO.inspect("# Advent of Code #")
    IO.inspect("##################")
    :timer.sleep(5)

    map
    |> Enum.map(&Enum.join(&1))
    |> IO.inspect(limit: :infinity)
  end
end

DaySix.run()
