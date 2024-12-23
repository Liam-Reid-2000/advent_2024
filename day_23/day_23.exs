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

    node_connections
    |> Enum.flat_map(fn {node, connections} ->
      connections
      |> Enum.flat_map(fn connected_node ->
        node_connections
        |> Enum.find(node_connections, fn {n, _} -> n == connected_node end)
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
    |> IO.inspect()
  end
end

DayTwentyThree.run()
