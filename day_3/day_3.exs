defmodule DayThree do
  def run() do
    input =
      "day_3_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

    part_1(input) |> IO.inspect(label: "Part 1")
    input |> part_2() |> part_1() |> IO.inspect(label: "Part 2")
  end

  defp part_1(input) do
    input
    |> Enum.map(fn line ->
      String.split(line, "mul(")
      |> Enum.map(fn x ->
        [h | _t] = String.split(x, ")")
        nums = h |> String.split(",")

        if length(nums) == 2 do
          num_1 = get_num(Enum.at(nums, 0))
          num_2 = get_num(Enum.at(nums, 1))

          if is_nil(num_1) or is_nil(num_2) do
            0
          else
            num_1 * num_2
          end
        else
          0
        end
      end)
    end)
    |> Enum.map(& Enum.sum(&1))
    |> Enum.sum()
  end

  defp part_2(input) do
    input
    |> Enum.join()
    |> String.split("do()")
    |> Enum.map(fn string ->
      if String.contains?(string, "don't") do
        if String.starts_with?(string, "don't") do
          ""
        else
          String.split(string, "don't", parts: 2) |> hd()
        end
      else
        string
      end
    end)
    |> List.flatten()
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, ""} -> num
      _ -> nil
    end
  end
end

DayThree.run()
