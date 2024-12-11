defmodule DayEleven do
  def run() do
    stones =
      "day_11_input.txt"
      |> File.read!()

    blink(stones, 25) |> IO.inspect(label: "Part 1")
    # blink(stones, 75) |> IO.inspect(label: "Part 2")
  end

  defp blink(stones, blinks) do
    stones =
      stones
      |> String.split(" ", trim: true)
      |> Enum.map(&transform_stone/1)
      |> Enum.join(" ")

    if blinks - 1 == 0 do
      stones
      |> String.split()
      |> Enum.count()
    else
      blink(stones, blinks - 1)
    end
  end

  defp transform_stone(stone) do
    cond do
      stone == "0" -> "1"
      stone_even(stone) -> split_stone(stone)
      true -> "#{get_num(stone) * 2024}"
    end
  end

  defp stone_even(stone) do
    stone_length = String.length(stone)
    rem(stone_length, 2) == 0
  end

  defp split_stone(stone) do
    stone_length = String.length(stone)
    half = div(stone_length, 2)
    {f_h, s_h} = String.split_at(stone, half)
    "#{trim_stone(f_h)} #{trim_stone(s_h)}"
  end

  defp trim_stone(stone) do
    new = String.trim_leading(stone, "0")
    if new == "", do: "0", else: new
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, _} -> num
      _ -> nil
    end
  end
end

DayEleven.run()
