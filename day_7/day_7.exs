defmodule DaySeven do
  def run() do
    input =
      "day_7_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

    input
    |> Enum.map(&possible_calibration(&1, :part_1))
    |> Enum.sum()
    |> IO.inspect(label: "Part 1")

    input
    |> Enum.map(&possible_calibration(&1, :part_2))
    |> Enum.sum()
    |> IO.inspect(label: "Part 2")
  end

  defp possible_calibration(input, part) do
    [target, nums] = input |> String.split(":")
    target = get_num(target)

    nums =
      nums
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&get_num/1)

    length = length(nums) - 1

    res =
      length
      |> generate_combinations(part)
      |> Enum.map(fn combination ->
        with_ops =
          Enum.zip(nums, combination)

        [h | t] = with_ops
        {first_num, :noop} = h

        Enum.reduce(t, first_num, fn
          {num, :add}, acc -> acc + num
          {num, :multiply}, acc -> acc * num
          {num, :concat}, acc -> get_num("#{acc}" <> "#{num}")
        end)
      end)

    if target in res, do: target, else: 0
  end

  defp generate_combinations(n, part) do
    1..n
    |> Enum.reduce([[]], fn _, acc ->
      for combination <- acc, operation <- parts(part) do
        combination ++ [operation]
      end
    end)
    |> Enum.map(&[:noop | &1])
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, ""} -> num
      _ -> nil
    end
  end

  defp parts(:part_1), do: [:add, :multiply]
  defp parts(:part_2), do: [:add, :multiply, :concat]
end

DaySeven.run()
