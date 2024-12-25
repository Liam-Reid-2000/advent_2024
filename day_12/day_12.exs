defmodule DayTwelve do
  @size 139

  def run() do
    input =
      "day_12_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    perimeters =
      for y <- 0..@size do
        for x <- 0..@size do
          cell = get_cell(input, {x, y})

          for coordinate <- [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}] do
            if cell != get_cell(input, coordinate), do: 1
          end
          |> Enum.filter(&(&1 == 1))
          |> Enum.sum()
        end
      end

    fields =
      for y <- 0..@size do
        IO.inspect(y)

        for x <- 0..@size do
          cell = get_cell(input, {x, y})
          make_field([], cell, input, {x, y})
        end
      end
      |> Enum.flat_map(& &1)
      |> Enum.uniq()

    fields
    |> Enum.map(fn field ->
      length(field) * perimeter_total(field, perimeters)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp perimeter_total(field, perimeters) do
    field
    |> Enum.map(&get_cell(perimeters, &1))
    |> Enum.sum()
  end

  defp make_field(field, cell, map, {x, y}) do
    field = List.flatten(field)

    if !is_nil(cell) and get_cell(map, {x, y}) == cell and {x, y} not in field do
      field = [{x, y} | field]

      field
      |> make_field(cell, map, {x + 1, y})
      |> make_field(cell, map, {x - 1, y})
      |> make_field(cell, map, {x, y + 1})
      |> make_field(cell, map, {x, y - 1})
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.sort()
    else
      field
    end
  end

  defp get_cell(_map, {x, _y}) when x < 0, do: nil
  defp get_cell(_map, {x, _y}) when x > @size, do: nil
  defp get_cell(_map, {_x, y}) when y < 0, do: nil
  defp get_cell(_map, {_x, y}) when y > @size, do: nil

  defp get_cell(map, {x, y}) do
    map
    |> Enum.at(y)
    |> Enum.at(x)
  end
end

DayTwelve.run()
