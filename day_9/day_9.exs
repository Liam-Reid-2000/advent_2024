defmodule DayNine do
  def run() do
    _input =
      "day_9_input.txt"
      |> File.read!()
      |> String.graphemes()
      |> Enum.map(&get_num/1)
      |> construct_disk([], 0)
      |> fill_disk([], 0)
      |> multiply_disk()
      |> IO.inspect()
  end

  defp multiply_disk(disk) do
    disk
    |> Enum.with_index()
    |> Enum.reduce(0, fn {char, index}, acc ->
      acc + index * get_num(char)
    end)
  end

  defp fill_disk(disk, new_disk, count) do
    IO.inspect(count)
    disk = trim_trailing_full_stops(disk)

    if "." not in (new_disk ++ disk) do
      new_disk ++ disk
    else
      {disk, tail} = pop_from_tail(disk)
      {start, rest} = add_tail_to_space(disk, tail)
      fill_disk(rest, new_disk ++ start, count + 1)
    end
  end

  defp add_tail_to_space(disk, tail) do
    disk
    |> Enum.reduce_while({[], disk}, fn _, acc ->
      {start, [h | t]} = acc

      if h == "." do
        {:halt, {start ++ [tail], t}}
      else
        {:cont, {start ++ [h], t}}
      end
    end)
  end

  defp pop_from_tail(disk) do
    last = List.last(disk)

    if last == "." do
      disk
      |> Enum.reverse()
      |> tl()
      |> Enum.reverse()
      |> pop_from_tail()
    else
      new_disk =
        disk
        |> Enum.reverse()
        |> tl()
        |> Enum.reverse()

      {new_disk, last}
    end
  end

  defp trim_trailing_full_stops(disk) do
    if List.last(disk) == "." do
      disk
      |> Enum.reverse()
      |> tl()
      |> Enum.reverse()
      |> trim_trailing_full_stops()
    else
      disk
    end
  end

  defp construct_disk([], disk, _), do: disk

  defp construct_disk(list, disk, count) when length(list) == 1 do
    [data] = list
    data = for _ <- 1..data, do: "#{count}"
    disk ++ data
  end

  defp construct_disk(nums, disk, count) do
    [data | [space | rest]] = nums

    data = for _ <- 1..data, do: "#{count}"

    space =
      if space == 0 do
        []
      else
        for _ <- 1..space, do: "."
      end

    append = data ++ space
    construct_disk(rest, disk ++ append, count + 1)
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, _} -> num
      _ -> nil
    end
  end
end

DayNine.run()
