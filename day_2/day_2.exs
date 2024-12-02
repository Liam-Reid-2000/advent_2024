defmodule DayTwo do
  def run() do
    safety_and_line =
      "day_2_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&get_safety/1)

    part_1 = part_1(safety_and_line)
    part_2 = part_2(safety_and_line)

    IO.inspect(part_1, label: "Part 1")
    IO.inspect(part_2 + part_1, label: "Part 2")
  end

  def part_1(safety_and_line) do
    safety_and_line
    |> Enum.map(fn {condition, _} -> condition end)
    |> Enum.count(& &1)
  end

  def part_2(safety_and_line) do
    safety_and_line
    |> Enum.reject(fn {condition, _} -> condition end)
    |> Enum.map(fn {_, line} ->
      0..length(line)
      |> Enum.reduce_while(-1, fn x, acc ->
        new_line =
          line
          |> Enum.with_index()
          |> Enum.reject(fn {data, index} -> index == x end)
          |> Enum.map(fn {data, _} -> data end)

        direction = get_direction(new_line)
        if is_safe?(new_line, direction) do
          {:halt, 1}
        else
          {:cont, acc}
        end
      end)
    end)
    |> Enum.count(& &1 == 1)
  end

  defp get_safety(line) do
    line =
      line
      |> String.split(" ")
      |> Enum.map(&get_num/1)

    direction = get_direction(line)
    {is_safe?(line, direction), line}
  end

  defp is_safe?(line, _direction) when length(line) <= 1, do: true
  defp is_safe?(line, direction) do
    [h | t] = line
    {min, max} = get_range(h, direction)
    [new_h | _new_t] = t

    if new_h >= min && new_h <= max do
      is_safe?(t, direction)
    else
      false
    end
  end

  defp get_range(num, :increasing), do: {num + 1, num + 3}
  defp get_range(num, :decreasing), do: {num - 3, num - 1}

  defp get_direction(line) do
    if Enum.at(line, 1) < Enum.at(line, 2) do
      :increasing
    else
      :decreasing
    end
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, _} -> num
      _ -> nil
    end
  end
end

DayTwo.run()
