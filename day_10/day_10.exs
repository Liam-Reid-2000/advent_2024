defmodule DayTen do
  @size 42
  def run() do
    map =
      "day_10_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.map(&get_num/1)
      end)

    map |> part_1() |> IO.inspect(label: "Part 1")
    map |> part_2() |> IO.inspect(label: "Part 2")
  end

  defp part_1(map) do
    map
    |> get_starting_coordinates()
    |> Enum.map(fn start_point ->
      [start_point]
      |> routes(map, 1)
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp part_2(map) do
    map
    |> get_starting_coordinates()
    |> Enum.map(fn start_point ->
      [start_point]
      |> routes(map, 1)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp routes(path, _map, 10) do
    List.last(path)
  end

  defp routes(path, map, next_num) do
    tail = List.last(path)

    for direction <- [:up, :down, :left, :right] do
      next_cell = next_cell(tail, map, direction)

      if next_cell == next_num do
        routes(path ++ [next_coordinate(tail, direction)], map, next_num + 1)
      end
    end
    |> List.flatten()
    |> Enum.filter(& &1)
  end

  defp next_cell(coordinate, map, direction) do
    next_coordinate = next_coordinate(coordinate, direction)
    get_cell(map, next_coordinate)
  end

  defp next_coordinate({x, y}, :up), do: {x, y - 1}
  defp next_coordinate({x, y}, :down), do: {x, y + 1}
  defp next_coordinate({x, y}, :left), do: {x - 1, y}
  defp next_coordinate({x, y}, :right), do: {x + 1, y}

  defp get_starting_coordinates(map) do
    for x <- 0..@size do
      for y <- 0..@size do
        if get_cell(map, {x, y}) == 0 do
          {x, y}
        end
      end
    end
    |> List.flatten()
    |> Enum.filter(& &1)
  end

  defp get_cell(_map, {x, y}) when x < 0 or y < 0, do: nil
  defp get_cell(_map, {x, y}) when x > @size or y > @size, do: nil

  defp get_cell(map, {x, y}) do
    map
    |> Enum.at(y)
    |> Enum.at(x)
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, _} -> num
      _ -> nil
    end
  end
end

DayTen.run()
