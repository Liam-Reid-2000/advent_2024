defmodule DayFive do
  def run() do
    input =
      "day_5_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

    rules =
      input
      |> Enum.take_while(&(&1 != "BREAK"))

    rules_tuple =
      rules
      |> Enum.map(fn x ->
        [num1, num2] = String.split(x, "|")
        {get_num(num1), get_num(num2)}
      end)

    pages = input -- rules
    pages = pages -- ["BREAK"]

    for page_set <- pages do
      page_set =
        page_set
        |> apply_rules(rules_tuple)

      Enum.at(page_set, div(length(page_set), 2))
    end
    |> Enum.sum()
    |> IO.inspect()

    # ANSWER IS TOO HIGH
  end

  defp apply_rules(page_set, rules) do
    nums_with_rules =
      page_set
      |> String.split(",")
      |> Enum.map(fn num ->
        num = get_num(num)
        {num, applicable_rules(num, rules)}
      end)

    construct_new_page_set(nums_with_rules, [])
  end

  defp applicable_rules(num, rules) do
    rules
    |> Enum.filter(fn {num1, _} -> num1 == num end)
    |> Enum.map(fn {_, num2} -> num2 end)
  end

  defp construct_new_page_set([], page_set), do: page_set

  defp construct_new_page_set(nums_with_rules, []) do
    [h | t] = nums_with_rules
    {num, _rules} = h
    construct_new_page_set(t, [num])
  end

  defp construct_new_page_set(nums_with_rules, page_set) do
    [h | t] = nums_with_rules
    {num, rules} = h

    page_set =
      if Enum.any?(rules, &(&1 in page_set)) do
        page_set ++ [num]
      else
        [num | page_set]
      end

    construct_new_page_set(t, page_set)
  end

  defp get_num(char) do
    case Integer.parse(char) do
      {num, ""} -> num
      _ -> nil
    end
  end
end

DayFive.run()
