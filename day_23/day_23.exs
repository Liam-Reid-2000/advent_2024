defmodule DayTwentyThree do
  def run() do
    connections =
      "day_23_input.txt"
      |> File.read!()
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "-"))

    nodes =
      connections
      |> List.flatten()
      |> Enum.uniq()

    node_connections =
      nodes
      |> Enum.map(fn node ->
        relevant =
          connections
          |> Enum.filter(&(node in &1))
          |> List.flatten()
          |> Enum.uniq()
          |> Enum.reject(&(&1 == node))

        {node, relevant}
      end)

    part_1(node_connections) |> IO.inspect(label: "Part 1")
    part_2(node_connections) |> IO.inspect(label: "Part 2")
  end

  defp part_2(node_connections) do
    node_connections
    |> Enum.map(fn {node, connections} ->
      [first | rest] = connections

      rest
      |> Enum.reduce([node, first], fn connected_node, acc ->
        connections =
          node_connections
          |> Enum.find(fn {n, _} -> n == connected_node end)
          |> elem(1)

        if Enum.all?(acc, &(&1 in connections)) do
          [connected_node | acc]
        else
          acc
        end
      end)
    end)
    |> Enum.max_by(&length(&1))
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp part_1(node_connections) do
    node_connections
    |> Enum.flat_map(fn {node, connections} ->
      connections
      |> Enum.flat_map(fn connected_node ->
        node_connections
        |> Enum.find(fn {n, _} -> n == connected_node end)
        |> elem(1)
        |> Enum.filter(&(&1 in connections))
        |> Enum.map(&{&1, node, connected_node})
      end)
    end)
    |> Enum.filter(fn {char_1, char_2, char_3} ->
      [char_1, char_2, char_3]
      |> Enum.any?(&String.starts_with?(&1, "t"))
    end)
    |> Enum.map(fn {char_1, char_2, char_3} ->
      [char_1, char_2, char_3] |> Enum.sort() |> List.to_tuple()
    end)
    |> Enum.uniq()
    |> Enum.count()
  end
end

DayTwentyThree.run()
