defmodule Advent2015 do
  @moduledoc """
  Documentation for Advent2015.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Advent2015.hello
      :world

  """
  def hello do
    :world
  end

  def follow(instructions) do
    tokens = instructions |> String.graphemes
    Enum.count(tokens, &(&1 == "(")) - Enum.count(tokens, &(&1 == ")"))
  end

  def find_basement(instructions), do: find_basement(instructions, 0, 0)
  def find_basement(_, -1, position), do: position
  def find_basement("(" <> t, current_floor, position) do
    find_basement(t, current_floor+1, position+1)
  end
  def find_basement(")" <> t, current_floor, position) do
    find_basement(t, current_floor-1, position+1)
  end

  defp tokenize(dimensions) do
    dimensions |> String.split("x") |> Enum.map(&String.to_integer/1)
  end

  defp drop_max(dimensions) do
    dimensions -- [Enum.max(dimensions)]
  end

  def wrap(dimensions) do
    [l, w, h] = tokenize(dimensions)
    2*l*w + 2*w*h + 2*h*l + ([l, w, h] |> drop_max |> Enum.reduce(&*/2))
  end

  def perimeter([h, w]), do: h*2+w*2

  def ribbon(dimensions) do
    [l, w, h] = tokenize(dimensions)
    l*w*h + ([l, w, h] |> drop_max |> perimeter)
  end

  def deliveries(instructions) do
    deliveries(instructions, {0, 0}, %{}) |> Enum.count
  end
  def deliveries("", pos, acc), do: Map.put_new(acc, pos, 1)
  def deliveries(">" <> t, {x, y} = pos, acc), do: deliveries(t, {x+1, y},
    Map.put_new(acc, pos, 1))
  def deliveries("<" <> t, {x, y} = pos, acc), do: deliveries(t, {x-1, y},
    Map.put_new(acc, pos, 1))
  def deliveries("^" <> t, {x, y} = pos, acc), do: deliveries(t, {x, y+1},
    Map.put_new(acc, pos, 1))
  def deliveries("v" <> t, {x, y} = pos, acc), do: deliveries(t, {x, y-1},
    Map.put_new(acc, pos, 1))

  def deliveries2(instructions) do
    instruction_list = String.graphemes(instructions)
    santa_instructions = Enum.drop_every([0|instruction_list], 2) |> Enum.join
    robot_instructions = Enum.drop_every(instruction_list, 2) |> Enum.join
    santa_deliveries = deliveries(santa_instructions, {0, 0}, %{})
    deliveries(robot_instructions, {0, 0}, santa_deliveries) |> Enum.count
  end

  def hashproducer(key, prefix \\ "00000") do
    Enum.find(0..1_000_000_000, fn n ->
      :crypto.hash(:md5, key <> Integer.to_string(n))
      |> Base.encode16 |> String.starts_with?(prefix)
    end)
  end

  def at_least(a, b), do: a >= b

  def vowel_count_at_least(map, count) do
    ["a", "e", "i", "o", "u"] |> Enum.map(fn v ->
        Map.get(map, v, 0)
    end) |> Enum.sum |> at_least(count)
  end

  defp count_occurrences(map) do
    Enum.reduce(map, %{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def has_three_vowels(string) do
    string |> String.graphemes
      |> count_occurrences
      |> vowel_count_at_least(3)
  end

  def contains_double_letter(string) do
    0..String.length(string)-2 |> Enum.any?(fn n ->
      String.slice(string, n, 1) == String.slice(string, n+1, 1)
    end)
  end

  def no_forbidden_substrings(string) do
    not String.contains?(string, ["ab", "cd", "pq", "xy"])
  end

  def has_non_overlapping_pair(string) do
    0..String.length(string)-2 |> Enum.map(fn n ->
      String.slice(string, n, 2)
    end) |> Enum.reduce(["_"], fn pair, acc ->
      if pair == hd(acc) do ["_"|acc] else [pair|acc] end
    end)
    |> count_occurrences
    |> Map.delete("_")
    |> Map.values
    |> Enum.any?(fn val -> val > 1 end)
  end

  def has_repeating_letter(string) do
    0..String.length(string)-3 |> Enum.any?(fn n ->
      String.slice(string, n, 1) == String.slice(string, n+2, 1)
    end)
  end

  def nice?(string) do
    has_three_vowels(string) && contains_double_letter(string)
      && no_forbidden_substrings(string)
  end

  def nicer?(string) do
    has_non_overlapping_pair(string) && has_repeating_letter(string)
  end

  def do_lights(map, "turn on", x1, x2, y1, y2) do
    for x <- String.to_integer(x1)..String.to_integer(x2),
        y <- String.to_integer(y1)..String.to_integer(y2) do
        {x, y}
    end |> Enum.reduce(map, fn key, acc ->
      Map.put(acc, key, true)
    end)
  end
  def do_lights(map, "turn off", x1, x2, y1, y2) do
    for x <- String.to_integer(x1)..String.to_integer(x2),
        y <- String.to_integer(y1)..String.to_integer(y2) do
        {x, y}
    end |> Enum.reduce(map, fn key, acc ->
      Map.put(acc, key, false)
    end)
  end
  def do_lights(map, "toggle", x1, x2, y1, y2) do
    for x <- String.to_integer(x1)..String.to_integer(x2),
        y <- String.to_integer(y1)..String.to_integer(y2) do
        {x, y}
    end |> Enum.reduce(map, fn key, acc ->
      Map.update(acc, key, true, fn val -> not val end)
    end)
  end

  def do_lights2(map, "turn on", x1, x2, y1, y2) do
    for x <- String.to_integer(x1)..String.to_integer(x2),
        y <- String.to_integer(y1)..String.to_integer(y2) do
        {x, y}
    end |> Enum.reduce(map, fn key, acc ->
      Map.update(acc, key, 1, fn val -> val + 1 end)
    end)
  end
  def do_lights2(map, "turn off", x1, x2, y1, y2) do
    for x <- String.to_integer(x1)..String.to_integer(x2),
        y <- String.to_integer(y1)..String.to_integer(y2) do
        {x, y}
    end |> Enum.reduce(map, fn key, acc ->
      Map.update(acc, key, 0, fn val ->
        if val == 0 do 0 else val - 1 end
       end)
    end)
  end
  def do_lights2(map, "toggle", x1, x2, y1, y2) do
    for x <- String.to_integer(x1)..String.to_integer(x2),
        y <- String.to_integer(y1)..String.to_integer(y2) do
        {x, y}
    end |> Enum.reduce(map, fn key, acc ->
      Map.update(acc, key, 2, fn val -> val + 2 end)
    end)
  end

  def lights(map, instruction) do
    [_, action, x1, y1, x2, y2] = ~r/(turn off|toggle|turn on) (\d+),(\d+) through (\d+),(\d+)/
      |> Regex.run(instruction)
    do_lights(map, action, x1, x2, y1, y2)
  end

  def lights2(map, instruction) do
    [_, action, x1, y1, x2, y2] = ~r/(turn off|toggle|turn on) (\d+),(\d+) through (\d+),(\d+)/
      |> Regex.run(instruction)
    do_lights2(map, action, x1, x2, y1, y2)
  end

  def day1a do
    day1_input() |> follow
  end

  def day1b do
    day1_input() |> find_basement
  end

  def day2a do
    day2_input()
      |> String.split("\n", trim: true)
      |> Enum.map(&wrap/1)
      |> Enum.sum
      |> Kernel.trunc
  end

  def day2b do
    day2_input()
      |> String.split("\n", trim: true)
      |> Enum.map(&ribbon/1)
      |> Enum.sum
  end

  def day3a do
    day3_input() |> String.replace("\n", "") |> deliveries
  end

  def day3b do
    day3_input() |> String.replace("\n", "") |> deliveries2
  end

  def day4a do
    hashproducer("iwrupvqb")
  end

  def day4b do
    hashproducer("iwrupvqb", "000000")
  end

  def day5a do
    day5_input()
      |> String.split("\n", trim: true)
      |> Enum.filter(&nice?/1)
      |> Enum.count
  end

  def day5b do
    day5_input()
    |> String.split("\n", trim: true)
    |> Enum.filter(&nicer?/1)
    |> Enum.count
  end

  def day6a do
    day6_input()
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn instr, acc ->
      lights(acc, instr)
    end)
    |> Map.values |> Enum.filter(&(&1)) |> Enum.count
  end

  def day6b do
    day6_input()
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn instr, acc ->
      lights2(acc, instr)
    end)
    |> Map.values |> Enum.sum
  end

  def day1_input do
  """
  ()(((()))(()()()((((()(((())(()(()((((((()(()(((())))((()(((()))((())(()((()()()()(((())(((((((())))()()(()(()(())(((((()()()((())(((((()()))))()(())(((())(())((((((())())))(()())))()))))()())()())((()()((()()()()(()((((((((()()())((()()(((((()(((())((())(()))()((((()((((((((())()((()())(())((()))())((((()())(((((((((((()()(((((()(()))())(((()(()))())((()(()())())())(()(((())(())())()()(()(()((()))((()))))((((()(((()))))((((()(()(()())())()(((()((((())((((()(((()()(())()()()())((()((((((()((()()))()((()))()(()()((())))(((()(((()))((()((()(()))(((()()(()(()()()))))()()(((()(((())())))))((()(((())()(()(())((()())))((((())))(()(()(()())()((()())))(((()((()(())()()((()((())(()()((())(())()))()))((()(())()))())(((((((()(()()(()(())())))))))(()((((((())((((())((())())(()()))))()(())(()())()())((())(()))))(()))(()((()))()(()((((((()()()()((((((((()(()(())((()()(()()))(())()())()((())))()))()())(((()))(())()(())()))()((()((()(()()())(())()()()((())())))((()()(()()((()(())()()())(((()(()()))))(())))(()(()())()))()()))))))()))))((((((())))())))(()(())())(()())))))(()))()))))))()((()))))()))))(()(()((()())())(()()))))(((())()))())())())(((()(()()))(())()(())(())((((((()()))))((()(()))))))(()))())(((()()(()))()())()()()())))))))))))))(())(()))(()))((()(())(()())(())())(()())(())()()(()())))()()()))(())())()))())())(())((())))))))(())))(())))))()))))((())(()(((()))))(()))()((()(())))(()())(((((()))()())()()))))()))))()))())(()(()()()))()))))))((()))))))))))()((()))((()(())((())()()(()()))()(()))))()()(()))()))(((())))(())()((())(())(()())()())())))))))())))()((())))()))(()))()()))(((((((()))())(()()))(()()(()))()(()((()())()))))))(((()()()())))(())()))()())(()()))()()))))))))(())))()))()()))))))()))()())))()(())(())))))()(())()()(()()))))())((()))))()))))(()(((((()))))))))())))())()(())()()))))(())))())()()())()()())()(()))))()))()))))))))())))((()))()))()))())))()())()()())))())))(()((())()((()))())))))())()(())((())))))))))))())()())(())())())(()))(()))()))())(()(())())()())()()(()))))(()(())))))))(())))())(())))))))())()()(())())())))(())))))()))()(()())()(()))())())))))()()(()))()))))())))))))))()))))()))))))())()())()()))))()())))())))))))))))()()))))()()(((()))()()(())()))))((()))))(()))(())())))(())()))))))(()))()))))(())())))))()))(()())))))))))))))())))))))))()((()())(()())))))))((()))))(())(())))()(()())())))())())(()()()())))()))))))())))))())()()())))))))))))()()(()))))()())()))((()())(()))))()(()))))))))))()())())(((())(()))))())()))()))()))))))()))))))(()))))()))))()(())))(())))(()))())()()(()()))()))(()()))))))))()))(()))())(()()(()(()())()()))()))))))))(())))))((()()(()))())())))))()))())(()())()()))())))()(()()()()))((())())))())()(()()))()))))))))(()))(())))()))))(()(()())(()))))()())())()))()()))())))))))))))())()))))))()))))))))())))))()))))())(()())))(())()))())())))))()()(()()())(()())))()()))(((()))(()()()))))()))))()))))((())))()((((((()()))))))())))))))))))(((()))))))))))))(())())))))())(()))))))(()))((()))())))()(()((()))()))()))))))))))())()))()(()()))))())))())(())()(()))()))())(()))()))))(()()))()()(())))))()))(())(()(()()))(()()())))))(((()))))))()))))))))))))(())(()))))()())())()()((()()))())))))(()))))())))))))()()()))))))))())))()(((()()))(())))))(((())())))))((()))()(()))(()))))(()())))(()))())))))()))))(())(())))()((()))(())())))()()))()))))))))()))(()()()(()()()(()))())(())()())(((()))(())))))))))(((()())))()()))))))))()(())(()))()((((())(())(()())))()))(((())()()()))((()))(()))())())))())))(()))())()())())(()(())())()()()(())))())(())))(())))(())()))()))(()((()))))))))())(()))))))())(()()))()()))()(()(()())))()()(()((()((((((()))(())))()()()))())()))((()()(()))())((()(()(()))(()()))))()())))()))()())))))))()()((()())(())))()))(()))(())(()))())(()(())))()()))))))(((()(((()()))()(()(())())((()()))()))()))()))()(()()()(()))((()())()(())))()()))(((())()()())(())()((()()()()(()(())(()()))()(((((()())))((())))))(()()()))))(((()(())))()))((()((()(())()(()((())))((()())()(()))(((()())()()(()))(())(((()((()())()((())()())(((()()))((()((())(()))(()())(()()()))((()))(())(()((()()())((()))(())))(())(())(())))(()())))(((((()(()(((((()())((((()(()())(())(()()(((())((()(((()()(((()()((((((())))())(()((((((()(()))()))()()((()((()))))()(()()(()((()()))))))(((((()(((((())()()()(())())))))))()))((()()(())))(())(()()()())))))(()((((())))))))()()(((()(()(()(()(()())()()()(((((((((()()())()(()))((()()()()()(((((((()())()((())()))((((((()(()(()(()())(((()(((((((()(((())(((((((((())(())())()))((()(()))(((()()())(())(()(()()(((()(())()))())))(())((((((())(()()())()()(((()(((())(()(((())(((((((()(((((((((()))(())(()(()(()))))((()))()(())())())((()(()((()()))((()()((()(())(())(()((())(((())(((()()()((((((()()(())((((())()))))(())((()(()((())))(((((()(()()())())((())())))((())((()((()()((((((())(((()()(()())())(()(()))(()(()))())())()(((((((()(((()(())()()((())((()(()()((()(()()(((((((((((())((())((((((())((()((((()(()((((()(((((((())()((()))))())()((()((((()(()(((()((()())))(())())(((()(((())((((((()(((((((((()()(())))(()(((((()((((()())))((()((()((()(()()(((())((((((((((((()(((())(()(((((()))(()()(()()()()()()((())(((((((())(((((())))))())()(()()(()(()(((()()(((((())(()((()((()(((()()((()((((())()))()((((())(())))()())(((())(())(()()((()(((()()((((((((((()()(()())())(((((((((())((((()))()()((((())(()((((()(((())())(((((((((((()((((())))(())(()(((()(((()((())(((((()((()()(()(()()((((((()((((()((()(()((()(()((((((()))))()()(((((()((()(()(())()))(())(((((((()((((()())(()((()((()(()))())))(())((()))))(((((((()()()())(()))(()()((()())()((()((()()()(()(()()))(()())(())(((((()(((((((((((()((()(((()(((((((()()((((((()(((((()(()((()(((((())((((((()))((((())((()()((())(((())()(((((()()(((((()((()(()(((((((()(((((()((()((()((())(())((())(()))()()))(()()(()(()()(((((((()(((()(((())()(((((()((((((()())((((())()((()((()(()()())(()))((((()()((((((()((()(()(()((((()((()((())((((((()(()(())((((((()((((((((((()((())()))()(()(()(((((()()()))((())))()(()((((((((((((((()(((()((((()((())((()((()(((()()(()(((()((())(()()())))()(()(()(((((()()(()(()((((()(((((())()(()(()))(((((()()(((()()(())((((((((((((((())((())(((((((((((())()()()(())()(()(()(((((((((())(((()))(()()())(()((((()(())(((((()())(())((((((((())()((((()((((((())(()((()(())(((()((((()))(((((((((()()))((((()(())()()()(())(()((())((()()))()(((())(((((())((((((()()))(((((((((()((((((())))(((((((()((()(()(())))())(()(()))()(((((()())(()))()(()(())(((()))))())()())))(((((()))())()((()(()))))((()()()((((((()))()()((((((((())((()(()(((()(()((())((()())(()((((())(()(((()()()(()(()()))())())((((((((((())())((()))()((())(())(())))())()(()()(())))())(()))(((()(()()(((()(((())))()(((()(())()((((((())()))()))()((((((()(()(((((()())))()))))())()()(((()(((((())((()()(()((()((()(()(()(())))(()()()()((()(())(((()((()))((((()))())(())))())(()))()()()())()))(((()()())()((())))(())(()()()()(()())((()(()()((((())))((()((()(())((()(()((())()(()()(((()())()()())((()))((())(((()()(())))()()))(((()((())()(((((()())(())((())()())())((((((()(()(((((()))(()(
  """
  end

  def day2_input do
  """
  20x3x11
  15x27x5
  6x29x7
  30x15x9
  19x29x21
  10x4x15
  1x26x4
  1x5x18
  10x15x23
  10x14x20
  3x5x18
  29x23x30
  7x4x10
  22x24x29
  30x1x2
  19x2x5
  11x9x22
  23x15x10
  11x11x10
  30x28x5
  22x5x4
  6x26x20
  16x12x30
  10x20x5
  25x14x24
  16x17x22
  11x28x26
  1x11x10
  1x24x15
  13x17x21
  30x3x13
  20x25x17
  22x12x5
  22x20x24
  9x2x14
  6x18x8
  27x28x24
  11x17x1
  1x4x12
  5x20x13
  24x23x23
  22x1x25
  18x19x5
  5x23x13
  8x16x4
  20x21x9
  1x7x11
  8x30x17
  3x30x9
  6x16x18
  22x25x27
  9x20x26
  16x21x23
  5x24x17
  15x17x15
  26x15x10
  22x16x3
  20x24x24
  8x18x10
  23x19x16
  1x21x24
  23x23x9
  14x20x6
  25x5x5
  16x3x1
  29x29x20
  11x4x26
  10x23x24
  29x25x16
  27x27x22
  9x7x22
  6x21x18
  25x11x19
  14x13x3
  15x28x17
  14x3x12
  29x8x19
  30x14x20
  20x23x4
  8x16x5
  4x11x18
  20x8x24
  21x13x21
  14x26x29
  27x4x17
  27x4x25
  5x28x6
  23x24x11
  29x22x5
  30x20x6
  23x2x10
  11x4x7
  27x23x6
  10x20x19
  8x20x22
  5x29x22
  16x13x2
  2x11x14
  6x12x4
  3x13x6
  16x5x18
  25x3x28
  21x1x5
  20x16x19
  28x30x27
  26x7x18
  25x27x24
  11x19x7
  21x19x17
  2x12x27
  20x5x14
  8x5x8
  6x24x8
  7x28x20
  3x20x28
  5x20x30
  13x29x1
  26x29x5
  19x28x25
  5x19x11
  11x20x22
  4x23x1
  19x25x12
  3x10x6
  3x14x10
  28x16x12
  23x12x2
  23x12x19
  20x28x10
  9x10x25
  16x21x16
  1x18x20
  9x4x26
  3x25x8
  17x16x28
  9x28x16
  27x3x12
  17x24x12
  13x21x10
  7x17x13
  6x10x9
  7x29x25
  11x19x30
  1x24x5
  20x16x23
  24x28x21
  6x29x19
  25x2x19
  12x5x26
  25x29x12
  16x28x22
  26x26x15
  9x13x5
  10x29x7
  1x24x16
  22x2x2
  6x16x13
  3x12x28
  4x12x13
  14x27x21
  14x23x26
  7x5x18
  8x30x27
  15x9x18
  26x16x5
  3x29x17
  19x7x18
  16x18x1
  26x15x30
  24x30x21
  13x20x7
  4x12x10
  27x20x11
  28x29x21
  20x14x30
  28x12x3
  19x1x8
  4x8x6
  21x14x2
  27x19x21
  17x24x14
  15x18x11
  18x7x26
  25x28x29
  27x26x9
  18x12x17
  24x28x25
  13x24x14
  26x9x28
  9x3x30
  9x2x9
  8x1x29
  18x30x10
  18x14x5
  26x8x30
  12x1x1
  30x5x28
  26x17x21
  10x10x10
  20x7x27
  13x17x6
  21x13x17
  2x16x8
  7x9x9
  15x26x4
  11x28x25
  10x6x19
  21x6x29
  15x5x6
  28x9x16
  14x3x10
  12x29x5
  22x19x19
  25x15x22
  30x6x28
  11x23x13
  20x25x14
  26x1x13
  6x14x15
  16x25x17
  28x4x13
  10x24x25
  4x13x10
  9x15x16
  15x24x6
  22x9x19
  11x11x8
  4x19x12
  24x5x4
  27x12x13
  7x27x16
  2x6x9
  29x27x15
  18x26x23
  19x16x15
  14x5x25
  9x16x30
  4x6x4
  13x10x10
  1x8x29
  23x5x17
  19x20x20
  11x27x24
  27x15x5
  15x11x12
  21x11x3
  1x13x22
  17x8x8
  13x14x14
  17x22x7
  9x5x8
  2x6x3
  25x9x15
  11x8x13
  9x25x12
  3x16x12
  12x16x8
  16x24x17
  4x6x26
  22x29x11
  14x17x19
  28x2x27
  24x22x19
  22x20x30
  23x28x4
  16x12x14
  22x24x22
  29x1x28
  26x29x16
  3x25x30
  27x3x13
  22x24x26
  25x3x2
  7x24x2
  10x5x3
  28x8x29
  25x6x4
  12x17x14
  24x3x5
  23x27x7
  26x23x30
  11x10x19
  23x7x11
  26x14x15
  14x3x25
  12x24x14
  2x14x12
  9x12x16
  9x2x28
  3x8x2
  22x6x9
  2x30x2
  25x1x9
  20x11x2
  14x11x12
  7x14x12
  24x8x26
  13x21x23
  18x17x23
  13x6x17
  20x20x19
  13x17x29
  7x24x24
  23x8x6
  19x10x28
  3x8x21
  15x20x18
  11x27x1
  11x24x28
  13x20x11
  18x19x22
  27x22x12
  28x3x2
  13x4x29
  26x5x6
  14x29x25
  7x4x7
  5x17x7
  2x8x1
  22x30x24
  22x21x28
  1x28x13
  11x20x4
  25x29x19
  9x23x4
  30x6x11
  25x18x10
  28x10x24
  3x5x20
  19x28x10
  27x19x2
  26x20x4
  19x21x6
  2x12x30
  8x26x27
  11x27x10
  14x13x17
  4x3x21
  2x20x21
  22x30x3
  2x23x2
  3x16x12
  22x28x22
  3x23x29
  8x25x15
  9x30x4
  10x11x1
  24x8x20
  10x7x27
  7x22x4
  27x13x17
  5x28x5
  30x15x13
  10x8x17
  8x21x5
  8x17x26
  25x16x4
  9x7x25
  13x11x20
  6x30x9
  15x14x12
  30x1x23
  5x20x24
  22x7x6
  26x11x23
  29x7x5
  13x24x28
  22x20x10
  18x3x1
  15x19x23
  28x28x20
  7x26x2
  9x12x20
  15x4x6
  1x17x21
  3x22x17
  9x4x20
  25x19x5
  9x11x22
  14x1x17
  14x5x16
  30x5x18
  19x6x12
  28x16x22
  13x4x25
  29x23x18
  1x27x3
  12x14x4
  10x25x19
  15x19x30
  11x30x4
  11x22x26
  13x25x2
  17x13x27
  11x30x24
  15x1x14
  17x18x4
  26x11x3
  16x22x28
  13x20x9
  1x18x3
  25x11x12
  20x21x1
  22x27x4
  8x28x23
  7x13x27
  17x9x26
  27x27x20
  11x20x12
  26x21x11
  29x14x12
  27x25x1
  28x29x25
  21x23x28
  5x18x18
  19x5x4
  7x6x30
  27x8x11
  12x24x12
  16x25x22
  26x11x29
  25x22x17
  15x23x23
  17x9x6
  30x10x16
  21x3x5
  18x27x2
  28x21x14
  16x18x17
  4x18x2
  9x1x14
  9x1x9
  5x27x12
  8x16x30
  3x19x19
  16x26x24
  1x6x9
  15x14x3
  11x7x19
  8x19x3
  17x26x26
  6x18x11
  19x12x4
  29x20x16
  20x17x23
  6x6x5
  20x30x19
  18x25x18
  2x26x2
  3x1x1
  14x25x18
  3x1x6
  11x14x18
  17x23x27
  25x29x9
  6x25x20
  20x10x9
  17x5x18
  29x14x8
  14x25x26
  10x15x29
  23x19x11
  22x2x2
  4x5x5
  13x23x25
  19x13x19
  20x18x6
  30x7x28
  26x18x17
  29x18x10
  30x29x1
  12x26x24
  18x17x26
  29x28x15
  3x12x20
  24x10x8
  30x15x6
  28x23x15
  14x28x11
  10x27x19
  14x8x21
  24x1x23
  1x3x27
  6x15x6
  8x25x26
  13x10x25
  6x9x8
  10x29x29
  26x23x5
  14x24x1
  25x6x22
  17x11x18
  1x27x26
  18x25x23
  20x15x6
  2x21x28
  2x10x13
  12x25x14
  2x14x23
  30x5x23
  29x19x21
  29x10x25
  14x22x16
  17x11x26
  12x17x30
  8x17x7
  20x25x28
  20x11x30
  15x1x12
  13x3x24
  16x23x23
  27x3x3
  26x3x27
  18x5x12
  12x26x7
  19x27x12
  20x10x28
  30x12x25
  3x14x10
  21x26x1
  24x26x26
  7x21x30
  3x29x12
  29x28x5
  5x20x7
  27x11x2
  15x20x4
  16x15x15
  19x13x7
  7x17x15
  27x24x15
  9x17x28
  20x21x14
  14x29x29
  23x26x13
  27x23x21
  18x13x6
  26x16x21
  18x26x27
  9x3x12
  30x18x24
  12x11x29
  5x15x1
  1x16x3
  14x28x11
  2x18x1
  19x18x19
  18x28x21
  2x3x14
  22x16x5
  28x18x28
  24x16x18
  7x4x10
  19x26x19
  24x17x7
  25x9x6
  25x17x7
  20x22x20
  3x3x7
  23x19x15
  21x27x21
  1x23x11
  9x19x4
  22x4x18
  6x15x5
  15x25x2
  23x11x20
  27x16x6
  27x8x5
  10x10x19
  22x14x1
  7x1x29
  8x11x17
  27x9x27
  28x9x24
  17x7x3
  26x23x8
  7x6x30
  25x28x2
  1x30x25
  3x18x18
  28x27x15
  14x14x1
  10x25x29
  18x12x9
  20x28x16
  26x27x22
  8x26x1
  21x2x12
  25x16x14
  21x19x5
  12x9x22
  16x5x4
  5x4x16
  25x29x3
  4x29x13
  15x16x29
  8x11x24
  30x11x20
  17x21x14
  12x24x10
  10x12x6
  3x26x30
  15x14x25
  20x12x21
  13x11x16
  15x13x3
  5x17x29
  6x3x23
  9x26x11
  30x1x8
  14x10x30
  18x30x10
  13x19x19
  16x19x17
  28x7x10
  28x29x4
  3x21x10
  4x28x24
  7x28x9
  2x4x9
  25x27x13
  6x12x15
  4x18x20
  20x1x16
  5x13x24
  11x11x10
  12x9x23
  1x9x30
  17x28x24
  9x5x27
  21x15x16
  17x4x14
  8x14x4
  13x10x7
  17x12x14
  9x19x19
  2x7x21
  8x24x23
  19x5x12
  11x23x21
  13x3x1
  5x27x15
  12x25x25
  13x21x16
  9x17x11
  1x15x21
  4x26x17
  11x5x15
  23x10x15
  12x17x21
  27x15x1
  4x29x14
  5x24x25
  10x10x12
  18x12x9
  11x24x23
  24x23x3
  28x12x15
  29x9x14
  11x25x8
  5x12x2
  26x26x29
  9x21x2
  8x8x25
  1x16x30
  17x29x20
  9x22x13
  7x18x16
  3x3x23
  26x25x30
  15x23x24
  20x23x5
  20x16x10
  23x7x8
  20x18x26
  8x27x6
  30x23x23
  7x7x24
  21x11x15
  1x30x25
  26x27x22
  30x28x13
  20x13x13
  3x1x15
  16x7x1
  7x25x15
  12x7x18
  16x9x23
  16x12x18
  29x5x2
  17x7x7
  21x17x5
  9x9x17
  26x16x10
  29x29x23
  17x26x10
  5x19x17
  1x10x1
  14x21x20
  13x6x4
  13x13x3
  23x4x18
  4x16x3
  16x30x11
  2x11x2
  15x30x15
  20x30x22
  18x12x16
  23x5x16
  6x14x15
  9x4x11
  30x23x21
  20x7x12
  7x18x6
  15x6x5
  18x22x19
  16x10x22
  26x20x25
  9x25x25
  29x21x10
  9x21x24
  7x18x21
  14x3x15
  18x19x19
  4x29x17
  14x10x9
  2x26x14
  13x3x24
  4x4x17
  6x27x24
  2x18x3
  14x25x2
  30x14x17
  11x6x14
  4x10x18
  15x4x2
  27x7x10
  13x24x1
  7x12x6
  25x22x26
  19x2x18
  23x29x2
  2x15x4
  12x6x9
  16x14x29
  9x17x3
  21x9x12
  23x18x22
  10x8x4
  29x2x7
  19x27x15
  4x24x27
  25x20x14
  8x23x19
  1x24x19
  6x20x10
  15x8x5
  18x28x5
  17x23x22
  9x16x13
  30x24x4
  26x3x13
  12x22x18
  29x17x29
  26x4x16
  15x7x20
  9x15x30
  12x7x18
  28x19x18
  11x23x23
  24x20x1
  20x3x24
  1x26x1
  14x10x6
  5x27x24
  13x21x12
  20x20x5
  6x28x9
  11x26x11
  26x29x12
  21x4x11
  20x11x17
  22x27x20
  19x11x21
  2x11x11
  13x5x7
  12x10x25
  21x28x1
  15x30x17
  28x19x1
  4x19x12
  11x4x12
  4x10x30
  11x18x5
  22x20x12
  3x7x27
  20x26x4
  13x27x26
  23x14x13
  4x19x7
  26x27x16
  20x5x20
  18x5x8
  19x21x1
  22x8x1
  29x4x1
  24x10x15
  24x9x20
  10x3x8
  29x30x3
  2x8x24
  16x7x18
  2x11x23
  23x15x16
  21x12x6
  24x28x9
  6x1x13
  14x29x20
  27x24x13
  16x26x8
  5x6x17
  21x8x1
  28x19x21
  1x14x16
  18x2x9
  29x28x10
  22x26x27
  18x26x23
  22x24x2
  28x26x1
  27x29x12
  30x13x11
  1x25x5
  13x30x18
  3x13x22
  22x10x11
  2x7x7
  18x17x8
  9x22x26
  30x18x16
  10x2x3
  7x27x13
  3x20x16
  9x21x16
  1x18x15
  21x30x30
  4x25x23
  3x11x7
  5x6x12
  27x1x20
  13x15x24
  23x29x2
  13x5x24
  22x16x15
  28x14x3
  29x24x9
  2x20x4
  30x10x4
  23x7x20
  22x12x21
  3x19x11
  4x28x28
  5x4x7
  28x12x25
  2x16x26
  23x20x7
  5x21x29
  9x21x16
  9x6x10
  9x6x4
  24x14x29
  28x11x6
  10x22x1
  21x30x20
  13x17x8
  2x25x24
  19x21x3
  28x8x14
  6x29x28
  27x10x28
  30x11x12
  17x2x10
  14x19x17
  2x11x4
  26x1x2
  13x4x4
  23x20x18
  2x17x21
  28x7x15
  3x3x27
  24x17x30
  28x28x20
  21x5x29
  13x12x19
  24x29x29
  19x10x6
  19x12x14
  21x4x17
  27x16x1
  4x17x30
  23x23x18
  23x15x27
  26x2x11
  12x8x8
  15x23x26
  30x17x15
  17x17x15
  24x4x30
  9x9x10
  14x25x20
  25x11x19
  20x7x1
  9x21x3
  7x19x9
  10x6x19
  26x12x30
  21x9x20
  15x11x6
  30x21x9
  10x18x17
  22x9x8
  8x30x26
  28x12x27
  17x17x7
  11x13x8
  5x3x21
  24x1x29
  1x28x2
  18x28x10
  8x29x14
  26x26x27
  17x10x25
  22x30x3
  27x9x13
  21x21x4
  30x29x16
  22x7x20
  24x10x2
  16x29x17
  28x15x17
  19x19x22
  9x8x6
  26x23x24
  25x4x27
  16x12x2
  11x6x18
  19x14x8
  9x29x13
  23x30x19
  10x16x1
  4x21x28
  23x25x25
  19x9x16
  30x11x12
  24x3x9
  28x19x4
  18x12x9
  7x1x25
  28x7x1
  24x3x12
  30x24x22
  27x24x26
  9x30x30
  29x10x8
  4x6x18
  10x1x15
  10x4x26
  23x20x16
  6x3x14
  30x8x16
  25x14x20
  11x9x3
  15x23x25
  8x30x22
  22x19x18
  25x1x12
  27x25x7
  25x23x3
  13x20x8
  5x30x7
  18x19x27
  20x23x3
  1x17x21
  21x21x27
  13x1x24
  7x30x20
  21x9x18
  23x26x6
  22x9x29
  17x6x21
  28x28x29
  19x25x26
  9x27x21
  5x26x8
  11x19x1
  10x1x18
  29x4x8
  21x2x22
  14x12x8
  """
  end

  def day3_input do
  """
  ^><^>>>^<^v<v^^vv^><<^<><<vv^<>^<^v>^vv<>v><vv^^<>>^^^v<<vv><<^>^<^v<^>^v><<<v^<v<<<v<<vv<v<^><^>><>v>v^<<v^^<^v<><^>^<<^^^>v>>v^^<v>>^>vv><v>>^>>v^>^v>^<^^v>^>^^v<v>^^<v<>>v^^v><^><^<<>v^<^<^v<v>v^>>>v^v^>^<>^v<^^vv<v>^>^<>^^<vv^<><<v<^<^^>vv<>^>v<^>^v>v^>^v<>^><>><vv<>v^v<><>v^v>>>>v^^>^><^^<v<^><^<v>>^v^v<>v<<<^<<vvvv<<v^vv^>v^^^<^^^<v>>v<^v>>>>>v<^^^^>v<^<><v>>>>><v>>v^vvvv^^<v^<>^v<^v^>v><^>^v<<>>vv^>v>v^^>vv^<^vvv<>><>><><^^^<v<>^<^^^<v><^v>>v>^v<v^vv^<>^^^>v^^^v>>^v^^<^>>^>^<<v>>>^^<>>^vv>v^<^>>>><v<><><^^v<><<<<^^<>>^<vvv^><>v<v<<<<><v<<v>v<v^><vv<v^>^<^>v^^><^v>^^>v<>^v^<>^vv^><v^^vv>vvv>v>^<vv^>>^>>^>><>>>^^^^v<vv>^<>v^^><v^>^<>v<^^v><v<<><^v><>^^^^^v^v>>^^v><<><<vv>^^^^><^>v>><<<^v>v^^>^v^<^^v>v<^<<>>^v<<<v<<>>v<^v^><vv<v^v>v^<v>><v>^v<<<vv^>v<v>>v>>v><v><v^>v^^v>^v^>>>><>^>v>^v^>>>>v^<<vv<^v><<>v<v^<^^<<v<^v^^v^>vv><vv<v^<^>><^^>^<><^^<v<><^v^v^<^^>^<v><^<v>v^<<<^^v<v>^v>>><>^^>vv<<^v^<<<<^^>>>v>v<<<>^^>>>v>^>v>vv<<>^<^><v^>^^<^<v<<v<^>>^v^<vvv><>v^><<v>^^<v^vv^^^<vvv^<^>^>vv>><^v<^<<v<><<><<^^<><><vv>v>^<v>>^<>>^^v>vv^<^^v>><^vv^<<v^^><<>vv<v<><v<><v^^^v^v>^v<^<>v^^>><>^<^<v^<v^v^>v<<<^<<^>>>^^<^^v>v^<v>vvvv>v<>><^>^<<<<v^<v<>v^^^v<>v>^<v<<^^v^^<>^<<v^^<^<v>v>>v>>v^>^<vv<<<<<^<><>v><>>>v^>^v<^<><<v<^v^^<^<><^>^^^>^><>^><<vv>^<>vv<<v^v<<<<<>>>v<vv>^v>^>^>^<^><>v<><>>>^^<v>^<^v>>^<><v^><v^>>>v<v^^vvv^><v<v>v^>vvvv>>><^>v<>^^^>v>>v^<v<>v^>^<v^>^<<^>^>>v<<><<v^^>>v^<v^<^v^>^>v^><<^<v>v^<v>>^^<<v>v><<<^v^<>^<>^>>^<<v>^^<>^v<>v^>>><<v>><v^>^><v^<><v><>><v^<>vv>v^<^^^>v>^^<vv>>^v<><>>><>><^<>>v>v^^>^^<^^>^>>v>vv^^v<^<^v><vv<v<^>><<vvv<<><^>^v>^^^<<>v^<v<v><<v>^^v<<<>^^vv<^>vv>^>^<><<>vv<^>v^vv>^^^v><<^vv>^v<><v^^^^v^>vv^^<^<>^^v^<^vv<v<vv<>v>v^^<>^^>^^>^<><<^v>^><^^vvvv<><>^<v^^>v<>^><>v>><>vv^<<><<>><>v<^>^v>>^^v><<<>>^<^v^<v<<<v^>^^<^<><><^><<<<^<vv><v<<><vvv^^><vv>^<<vv<<<^v<>>><><>>v><<<v>vvvv^^vv<v>><<^v^vvv><><vv>v><>v<<<^<v^>><^^>v^<v>><v>^^^v^v>><<<v<^^>>^v<>v^<vv^^<<v<v>v<<<<^^^v^v<<>>>v>>vv>^^<><^v<v><>>v^>>>>>^>v^v^<^v^v^vvv>v<v<^>vv^<<v>vv>>v^^vv<^v>>>>vv<>v<>^^vv^<v>v^>>vvv<<<v<<^vv^^^^>v>v>^><<<^>v^><v<^<<<v>^v^^^><<><<<^^<^^<>^<v>^<v<<v<^^vv>v<^v><v><v<>^v<^<v<^<v^v><v>><v<v<<>^<v<>>><>^v^v<<^><v^<<v<v^>^>v><^>^vv^^<v<v<vv<v>^v^v^>^<<>>>>>v^<>^>v^vv^><<>>^^<>v^><v>^vvv^>v^v><>^><<>v>v<^<^><^^vv<<><>>v>>v><vv>>^v<<>^vv<>^vv>v>v>^>^>>><><<>v<v>^<<^v^^<<<><v>>vv<^<vv<vv^<<v<<^v><<>v<^^^<<^v^>^v>^^^v^v>>>v>v^v>^>^vv<^^<<vv^>^<<<vv>v^<><<^vvv^^><>vv^v>v>^><<^^^^vvv^<vvv>><^v<^>^<>>^<v<<vv>>><v>vv^<>><v^<v>^v>^>v>^<^<^^^<<vvvv^>>>>>>>v><vv>^<>^^v^><>><^v^^<v^v<<<<v^>><>v^v<vv<><^<<<<^>^^>vv>><^v<v^v<<>^vvv>v^^><^^<^<>>^^v^vv<>v<^<<<v^^^><v<vv<<>v>v<>^v^><v^vv^v^^v<^^v^^v><>v<^v>><<^<^v^>><<vv<<^>^<<v^<>^><>v><vv^v>>^<v<<<^>vv<^v>^>v<<v>^>>^>>v^<v<v>>^v<^v^v><<><>^><<<><v<vvvv<v^<v^v><>^<>^^^^v>^>^vvvvv>v>>v><<vv<<v<><<^><<^v><<v<<<v><vv<^>^v>>>>^v<^v<<>>^>^<<vv^<^>v>><<^>^>^v><><>^><<v<>v^><<^v^<^^><^^v^<<^v^^>>^v^<^><vv>v^^<<^^^<><>^>v^v>v^>^v^vv>^^>>>>^^<^>>>^^v<vv<><^^<vvv<^^^vv>v<v<v>><<<>^>^^>^>^v<<<<>>^<<>><v>>v>^^<^v<>v<>v^>v^><^<^^><v^^v>^^vv<v<<>><<vv<>>v>^<<<<v<<v>^><^^<^<^<v^<<^^v>^v<^>v^v^<v^vv^>^^><^>v^v>>^^v^><vv<v<v<v>>>>><<><v><v^v^<v^<^^<v<>^>v>v<>>>v>^^^^>><v^v^^v<<<>v^<<^<v>>>><^v^<<><v<>>v><><v<v^v>^v^^<v<^<^^v>><<vv<<vv><>>^>^>vv<^<>^vvv^v<v^^<>v^v>^^<<<<<>^v^>^<>v^^<>v^v<vv>^<>vv^<^vv>><v^^vvvvv>><<>v<vv^<^<vv^v^<>^^<v^<vv^<v^v^v<<^>^>^>^^>>>vvv>^>v>v>>>^>vv^><>^><>v>^^<v^>^><<v>><<<>>v<vvvv^>^v<^<>^<v>^<>^^<<><>^v<><>>>^vv<^<<^<^v>v<<<<<^^v<^v<><v<<><^>v>^v>>^v^><^^^^v<><><>vv^<>vv<^v<^^><v^<^><^^v^v^<^^<<><v>v<v<v^<<^v><>v^v<^>vvv><<^v>>v><><v<<^>>>v<^>>v>^<>><>^<v^v^<vv<<^>v<^^>^<^v<^<<^^v<>>^>^>^v^^v^v<v^^vv^<v>>v><vv^vv>v<>v^>v^^>^^>><v><v^<<><<>><<^^>><^v<v<><<><<><v<v^<^<v>>>><v^^v^^>>>^^^^^<<vv<^><>^<<<vv^^^>^><<<v<^v>^<v<^>^vvv<<>vv><<>v>v^v>>>>>^<>><^^^><<<<v><<vv>>>v<^<vv^v^<<v>>>>^^vvv>v<>><v>>>v>>^v^vvv<<>vvv<<^^^<>vv^^v<<>^^^>>^<^v^<^^>v^><v>>^<<^v<<vv<vv>v^>>^>v^><^><>^>>>vv>><^^^>vv<<^^vv><^<>^>^^<^<>>^vv^>>^v><>v^>>><<<^^<^>^>v<^>^<^^<>>><^^<>^v^<<vvv<v><>vvv><v>v^v<<^<v>^^><<^vv^v>v>v<<^v^<<<>^><><vvv>v>^vv^v<>vv^>^^<^>^>v^^<vv^>v><v<<<><>>^v<^<><><^<v^^<<^<v>vv<><<>v^<v^>^>^^<><<>^<^<<v^^v<v^<><<>v>><^<<>^>^v^v<v^v><^>>^v<^>v<<>^^^<^v>>>^<v>vvvv<<v^<^^>vvvv>v<>v<v><vvvvv>^<><>vvv<>^<<>^>>>>v^<^<><^v>v^>>v><>^><<v^>^<<>^>^v^<v^^>>^v><v>^<v><>v^<^^>v>^>>>v^v>>>^<>^<>>>>>v>>vv^v<><<<><><v><<vv<<v<><>>vv<^<vv>^v<<>v^v<^v<><v>>^v>>vvv^^v>>v>^>^>v><v><^>^^<<>^v<^<<<<^>v<^>>v^<^v>^v<<>^>^vvv<^^vv>^vv>vv<>>v>v<v>>v^<<<<<^^v^>v>^<<<v^v>>v<v><vvv><v>^<vv><<>>^<^>^^<>>>>^<^v<>v^^>^<^^v<^><>><v>>^v^vv<^v<^><<vvv<>><>><^^>^<^v^<^<>v<<<^v>v^^^<>v^<v^>^v^>><>^^<v<^><<^^v^<>^<^vv>>><^v><v^>vv<^v<<<v^>>v>v^v>^<v>v<^<>v^vvv>^vv<<<<v><^><v>>^^>><^v><<^>v^^<<v^^<^<><<<<>^<v<^v^>v<<^^>v<<<<<vvv<v<^>^>^>^>>^>>>v^<<v>>^^v><vv<^v<v<^^^>>>^vvv<^v<>>>vv>^^><^v>vv^>>v>v^<>^<vv>^>^<<^>^^^>>^vv>^^>vvvv<>>^^^^>>>v>v^^>vv>vv^<<>^><^<v^vvvv><v<><v>><<<v<v<<^v><vv^vv^<>>>^>^<v<^v<>><^<vv^^><v>v^>v^<><v^vvv>^>v^^v^>^^>v<<<<^<<^>>v>v^^^<<<v>>>^^v>v<v><<<<^^^v>^vv^>><>^v<v<<^^<<<<><>>>v>vvv^v^^v^>>vv>^>><>^v><^v^><^^>vv>^<^<^>><v>v>><><><v>^>^>v>vv>vv>^^>v>v^><v<<v^<>^>^v>^^v>^<^v<>>vvv^^>^>vv<v<v<<^<^<v^<>v^^v<^<^>vv^^<v><^^^>v>vv<<v>v<<v^<v^^><vv>^>^v^<^>v<^>^<>vv^><v<^><>>^>>^<^><<>^<^>v>v><>>>^<<^><<v><^v<v><>>vv<^><v^>>v>v>>>>^^>v<^v^>><<^<>>v><^><<^>^<vv^^<><<>><vvvv^>^^<><^^v>^^>vv>^v<v>>^^v^<v<^><^<<>>v^^^<^><^<<><<v<>><<>^v>vvv^vvv^^>>^<^<v>><>^<<<<^^<>>>v^<<^^v>><><<v<^>v>^v<v^>v>vv^><>^><<><^^>^>^<><>><^^<v^v<^><><><v>^<v<<v^<<^^^v<v<^v<>>><^v<<<<>>^v>^^vv^v^<<v>><<<v>vv>>v>>^v^<>>vv^<^>^<<>v<<<^vv<^vv^vv<^v^^^<vv^>v>>v<^^<^^vvv<^^v<>>>^>v^><v>^^><>vv>v>v<<<^^v<^vv^v>^^^>>>^^<>^^<^vvv>><><<><^<v>><<>^>^^<v^v^>vv>vv<v>^^<^^<<><><<v><v^^>v><v><<>v>vvv<^^^^<^>>><<<^^^<^>vv^^v>>v<<v^^<vv^<^>vvv^^v^^<^<vv>v<^<>^<<vv^^>^v>>^><><>v<v<v<>><v>>>^^>>v^><v^^<^>><>v<><<v^v<v<<>>>><>>>>><<^vvv<<><><<>^><><<^^v><<^>v>^>^v>v>>^^<><^>vv<^<^v>v<><^<<v<><^><>^^^<v^<><vvv^^^<>^^v><v<<<v>><>^>^vv<v^<vv>v>v^vv<v^v<v>^v^>v><>v^><>v>^^^^><<vv^><v<<v<^<>^v^^^>^^><<<v<^<v^>^^>v><vvvvv^<^<v^^>v<^v^^vv^<<<<v><^>v>v^v><><v^<<^<<v<^^^>^><v^v^<><><>^v<v>^<>^v>^v>v^<><^><v>>v<<^><^vv^<><^<>><>><v<v><<^^^^>v<^<^vv<><^vv><<^<<v>v^>>^v>^>v^^v>vv<v>v<<v>v<>^>>vv^>>><>^v^^<^>v<<^<^^v^^v^<<v<<v<^v<>vv^<v>><^v<^>>>vv^^<v^<>^^v<v<v>>^><^^^<><<^^>v<<vv>><<vvv>><<v^v^>><>vv^><<^>^><^v<^<^<vv<^^vv>v^v<<<<<<><<vv^vv>vv>v<^><<><><<>>v>><v><^>^v>^v^<>v^^^><^^<<<^vv^vv>^v^vvv^^>v^<v>><^<^<^<>^vv<vv^v^^>^^^>vv^v>>><<<^<>>v>v<^^<><v>>><><^v^^<<><<<>^<^^v^>v<vv^^^^>><v><^<<v<<v<>^>^>>^<>^v><>>^<v<vv^<<^<<>vv^>^^<<<^v<>>^v<>vvv<<^^<<><vvvvv<<^<^^<>>>>^^<><>^><>^v<v^^v<<v^^<^<^>v<v>^v<^>^v<>v^vv<><<v>^vvv<><<^>>^^><><>^<>^>v^^v^><v<><>>v><v^<v<<v>><^v>^<v<^>v<<<>vvv^<^^v<vvv^vv<>^<>^>>v<>^^><><v>>^><^^vv>><<>><v><^><>>^vv>v<vv<>v^v^^v<<^^<vv>v^^vv<<^<<><>^<><v^><^<^<>>^vv<v>v>>^<^vv>^vv^>v>^<><^><^<>v^v^^<^<>^^v>>><^v<>v^v<<^>v><>^^<<v^v<>v^>>v>^<><vv^v<v^<vv<>^>^>^<^>v><<><><><<<>^>><v^^><^>><v>>^v<<<^<<>^><<^>>>>>v<^>v>>v^<v^>^>v^^><>v^v^vvvv<v<v<>v>>><<>^<<vvv><v^v^>v<v^^^>>^<v>>^vv^^<vv><^>>v<v^><vvv<^^>>vv^v<^<>^v^<<v>^<<><<<^vvv^>^^<<>>><v<^>vv<<^<><^v<^<><<^^>vv^v>v^^^>>>>^>vv<<v>v>>^^v^^><>v<<^><^<v^>>^>v^v>><^v^>v<<^<v><^<^<^<>>v^^>><<<>v<v>v<^^>^vv<<<^^<v<>v^^>v<<><^<>^^>^v<>v>><^^^vv^>^><>v^^<v^<>>^<v^^^><v<><vvv>v>^<<^v>^>>>>><^^^<>v<v>>v^^<^v^>>v^<<v^>^>v^v>>>>^>>vv<>^<^v><v^^<>v>v^v>^<>^>v<vv><<v<^v<<^v<<^v^vv<><>^<>>^<>>^<>v^><<>^v>>^^^^<<^v><>^<^>^^v><^^<^<v^<^^v>^v><vv>v<<^>^>><<^^^vvv<<^vv<^^>v^^vv^<^^<<^^>>^^<vv<v<<v^^<<v<^vvv<<><<v>v^>>v^^>v<^>^><v<^>v<v^v<v^^<>v>><<v^v^v<^^^><v>v><^<^vv>^^v>^>v<<^vv><^^^^^^><<^>>>^v<>^^v<<<>><<<v^><>^<<<v>v^>^^^<^><v>^^^v<<>v<v>^<v^>><<^^<<^v<<>^v>>vv>><v<^><v<<<vvv><vv><<^v^^<v^vvv<^v>>v^v<v^v^>>^^v<><^^^<^^>v>^<><v<<v^^>vvv^v^^<v<v^v>^>v^^v<^><v^^<<<<>^^>>^v<><^><^<<^vv^<><<>v^vv^<v^<><<<^^>v<<>>>v<>v<><<<v>^v>^^v>^^>v>^>^>v<>><>^>^>^vvvv<^<v^<>^^^^v>v>><<v>>^<vv>>^<v<^v^vv>><>^^>v^^<<><^<v>><<<<>v>^^><v^^v<<v<><vv^v>^<v^^>v<<<<v^v<<>>vv<v<<<v>v>>v<^v>>v>v^<<<>^>^>^<>v<^^vv><^v<<^v<vvv^vv>v<^<<^^vv^^>vv<^>v>^^<<v^<<^^v<>^>v<<^^<^>^^^v^^<v<^<^>>>v^vv^<^v>^<>^<^<v<^v>>>^<^v<><v<^vv<v>v><v^v^^v<vv><^^<><>^>v<^<^vv>><^v><v<>^<>^^>^<><<<v^>>^<>><<><v>vvv^<<^<vv<v><v<^<<<^>^>>v<^>>vv>^v^^^v<>v<>><>^vv^>vv^
  """
  end

  def day5_input do
  """
  sszojmmrrkwuftyv
  isaljhemltsdzlum
  fujcyucsrxgatisb
  qiqqlmcgnhzparyg
  oijbmduquhfactbc
  jqzuvtggpdqcekgk
  zwqadogmpjmmxijf
  uilzxjythsqhwndh
  gtssqejjknzkkpvw
  wrggegukhhatygfi
  vhtcgqzerxonhsye
  tedlwzdjfppbmtdx
  iuvrelxiapllaxbg
  feybgiimfthtplui
  qxmmcnirvkzfrjwd
  vfarmltinsriqxpu
  oanqfyqirkraesfq
  xilodxfuxphuiiii
  yukhnchvjkfwcbiq
  bdaibcbzeuxqplop
  ivegnnpbiyxqsion
  ybahkbzpditgwdgt
  dmebdomwabxgtctu
  ibtvimgfaeonknoh
  jsqraroxudetmfyw
  dqdbcwtpintfcvuz
  tiyphjunlxddenpj
  fgqwjgntxagidhah
  nwenhxmakxqkeehg
  zdoheaxqpcnlhnen
  tfetfqojqcdzlpbm
  qpnxkuldeiituggg
  xwttlbdwxohahwar
  hjkwzadmtrkegzye
  koksqrqcfwcaxeof
  wulwmrptktliyxeq
  gyufbedqhhyqgqzj
  txpunzodohikzlmj
  jloqfuejfkemcrvu
  amnflshcheuddqtc
  pdvcsduggcogbiia
  yrioavgfmeafjpcz
  uyhbtmbutozzqfvq
  mwhgfwsgyuwcdzik
  auqylgxhmullxpaa
  lgelzivplaeoivzh
  uyvcepielfcmswoa
  qhirixgwkkccuzlp
  zoonniyosmkeejfg
  iayfetpixkedyana
  ictqeyzyqswdskiy
  ejsgqteafvmorwxe
  lhaiqrlqqwfbrqdx
  ydjyboqwhfpqfydc
  dwhttezyanrnbybv
  edgzkqeqkyojowvr
  rmjfdwsqamjqehdq
  ozminkgnkwqctrxz
  bztjhxpjthchhfcd
  vrtioawyxkivrpiq
  dpbcsznkpkaaclyy
  vpoypksymdwttpvz
  hhdlruwclartkyap
  bqkrcbrksbzcggbo
  jerbbbnxlwfvlaiw
  dwkasufidwjrjfbf
  kkfxtjhbnmqbmfwf
  vmnfziwqxmioukmj
  rqxvcultipkecdtu
  fhmfdibhtjzkiqsd
  hdpjbuzzbyafqrpd
  emszboysjuvwwvts
  msyigmwcuybfiooq
  druyksfnbluvnwoh
  fvgstvynnfbvxhsx
  bmzalvducnqtuune
  lzwkzfzttsvpllei
  olmplpvjamynfyfd
  padcwfkhystsvyfb
  wjhbvxkwtbfqdilb
  hruaqjwphonnterf
  bufjobjtvxtzjpmj
  oiedrjvmlbtwyyuy
  sgiemafwfztwsyju
  nsoqqfudrtwszyqf
  vonbxquiiwxnazyl
  yvnmjxtptujwqudn
  rrnybqhvrcgwvrkq
  taktoxzgotzxntfu
  quffzywzpxyaepxa
  rfvjebfiddcfgmwv
  iaeozntougqwnzoh
  scdqyrhoqmljhoil
  bfmqticltmfhxwld
  brbuktbyqlyfpsdl
  oidnyhjkeqenjlhd
  kujsaiqojopvrygg
  vebzobmdbzvjnjtk
  uunoygzqjopwgmbg
  piljqxgicjzgifso
  ikgptwcjzywswqnw
  pujqsixoisvhdvwi
  trtuxbgigogfsbbk
  mplstsqclhhdyaqk
  gzcwflvmstogdpvo
  tfjywbkmimyyqcjd
  gijutvhruqcsiznq
  ibxkhjvzzxgavkha
  btnxeqvznkxjsgmq
  tjgofgauxaelmjoq
  sokshvyhlkxerjrv
  ltogbivktqmtezta
  uduwytzvqvfluyuf
  msuckpthtgzhdxan
  fqmcglidvhvpirzr
  gwztkqpcwnutvfga
  bsjfgsrntdhlpqbx
  xloczbqybxmiopwt
  orvevzyjliomkkgu
  mzjbhmfjjvaziget
  tlsdxuhwdmghdyjb
  atoecyjhwmznaewi
  pyxpyvvipbqibiox
  ajbfmpqqobfsmesj
  siknbzefjblnohgd
  eqfhgewbblwdfkmc
  opylbscrotckkrbk
  lbwxbofgjkzdxkle
  ceixfjstaptdomvm
  hnkrqxifjmmjktie
  aqykzeuzvvetoygd
  fouahjimfcisxima
  prkzhutbqsyrhjzx
  qqwliakathnsbzne
  sayhgqtlcqqidqhj
  ygduolbysehdudra
  zricvxhdzznuxuce
  ucvzakslykpgsixd
  udirhgcttmyspgsb
  yuwzppjzfsjhhdzi
  gtqergjiuwookwre
  xvxexbjyjkxovvwf
  mlpaqhnnkqxrmwmm
  ezuqbrjozwuqafhb
  mcarusdthcbsonoq
  weeguqeheeiigrue
  pngtfugozxofaqxv
  copphvbjcmfspenv
  jiyahihykjjkdaya
  gdqnmesvptuyrfwp
  vbdscfywqmfxbohh
  crtrfuxyjypzubrg
  seihvevtxywxhflp
  fvvpmgttnapklwou
  qmqaqsajmqwhetpk
  zetxvrgjmblxvakr
  kpvwblrizaabmnhz
  mwpvvzaaicntrkcp
  clqyjiegtdsswqfm
  ymrcnqgcpldgfwtm
  nzyqpdenetncgnwq
  cmkzevgacnmdkqro
  kzfdsnamjqbeirhi
  kpxrvgvvxapqlued
  rzskbnfobevzrtqu
  vjoahbfwtydugzap
  ykbbldkoijlvicbl
  mfdmroiztsgjlasb
  quoigfyxwtwprmdr
  ekxjqafwudgwfqjm
  obtvyjkiycxfcdpb
  lhoihfnbuqelthof
  eydwzitgxryktddt
  rxsihfybacnpoyny
  bsncccxlplqgygtw
  rvmlaudsifnzhcqh
  huxwsyjyebckcsnn
  gtuqzyihwhqvjtes
  zreeyomtngvztveq
  nwddzjingsarhkxb
  nuqxqtctpoldrlsh
  wkvnrwqgjooovhpf
  kwgueyiyffudtbyg
  tpkzapnjxefqnmew
  ludwccvkihagvxal
  lfdtzhfadvabghna
  njqmlsnrkcfhtvbb
  cajzbqleghhnlgap
  vmitdcozzvqvzatp
  eelzefwqwjiywbcz
  uyztcuptfqvymjpi
  aorhnrpkjqqtgnfo
  lfrxfdrduoeqmwwp
  vszpjvbctblplinh
  zexhadgpqfifcqrz
  ueirfnshekpemqua
  qfremlntihbwabtb
  nwznunammfexltjc
  zkyieokaaogjehwt
  vlrxgkpclzeslqkq
  xrqrwfsuacywczhs
  olghlnfjdiwgdbqc
  difnlxnedpqcsrdf
  dgpuhiisybjpidsj
  vlwmwrikmitmoxbt
  sazpcmcnviynoktm
  pratafauetiknhln
  ilgteekhzwlsfwcn
  ywvwhrwhkaubvkbl
  qlaxivzwxyhvrxcf
  hbtlwjdriizqvjfb
  nrmsononytuwslsa
  mpxqgdthpoipyhjc
  mcdiwmiqeidwcglk
  vfbaeavmjjemfrmo
  qzcbzmisnynzibrc
  shzmpgxhehhcejhb
  wirtjadsqzydtyxd
  qjlrnjfokkqvnpue
  dxawdvjntlbxtuqc
  wttfmnrievfestog
  eamjfvsjhvzzaobg
  pbvfcwzjgxahlrag
  omvmjkqqnobvnzkn
  lcwmeibxhhlxnkzv
  uiaeroqfbvlazegs
  twniyldyuonfyzqw
  wgjkmsbwgfotdabi
  hnomamxoxvrzvtew
  ycrcfavikkrxxfgw
  isieyodknagzhaxy
  mgzdqwikzullzyco
  mumezgtxjrrejtrs
  nwmwjcgrqiwgfqel
  wjgxmebfmyjnxyyp
  durpspyljdykvzxf
  zuslbrpooyetgafh
  kuzrhcjwbdouhyme
  wyxuvbciodscbvfm
  kbnpvuqwmxwfqtqe
  zddzercqogdpxmft
  sigrdchxtgavzzjh
  lznjolnorbuddgcs
  ycnqabxlcajagwbt
  bnaudeaexahdgxsj
  rlnykxvoctfwanms
  jngyetkoplrstfzt
  tdpxknwacksotdub
  yutqgssfoptvizgr
  lzmqnxeqjfnsxmsa
  iqpgfsfmukovsdgu
  qywreehbidowtjyz
  iozamtgusdctvnkw
  ielmujhtmynlwcfd
  hzxnhtbnmmejlkyf
  ftbslbzmiqkzebtd
  bcwdqgiiizmohack
  dqhfkzeddjzbdlxu
  mxopokqffisxosci
  vciatxhtuechbylk
  khtkhcvelidjdena
  blatarwzfqcapkdt
  elamngegnczctcck
  xeicefdbwrxhuxuf
  sawvdhjoeahlgcdr
  kmdcimzsfkdfpnir
  axjayzqlosrduajb
  mfhzreuzzumvoggr
  iqlbkbhrkptquldb
  xcvztvlshiefuhgb
  pkvwyqmyoazocrio
  ajsxkdnerbmhyxaj
  tudibgsbnpnizvsi
  cxuiydkgdccrqvkh
  cyztpjesdzmbcpot
  nnazphxpanegwitx
  uphymczbmjalmsct
  yyxiwnlrogyzwqmg
  gmqwnahjvvdyhnfa
  utolskxpuoheugyl
  mseszdhyzoyavepd
  ycqknvbuvcjfgmlc
  sknrxhxbfpvpeorn
  zqxqjetooqcodwml
  sesylkpvbndrdhsy
  fryuxvjnsvnjrxlw
  mfxusewqurscujnu
  mbitdjjtgzchvkfv
  ozwlyxtaalxofovd
  wdqcduaykxbunpie
  rlnhykxiraileysk
  wgoqfrygttlamobg
  kflxzgxvcblkpsbz
  tmkisflhativzhde
  owsdrfgkaamogjzd
  gaupjkvkzavhfnes
  wknkurddcknbdleg
  lltviwincmbtduap
  qwzvspgbcksyzzmb
  ydzzkumecryfjgnk
  jzvmwgjutxoysaam
  icrwpyhxllbardkr
  jdopyntshmvltrve
  afgkigxcuvmdbqou
  mfzzudntmvuyhjzt
  duxhgtwafcgrpihc
  tsnhrkvponudumeb
  sqtvnbeiigdzbjgv
  eczmkqwvnsrracuo
  mhehsgqwiczaiaxv
  kaudmfvifovrimpd
  lupikgivechdbwfr
  mwaaysrndiutuiqx
  aacuiiwgaannunmm
  tjqjbftaqitukwzp
  lrcqyskykbjpaekn
  lirrvofbcqpjzxmr
  jurorvzpplyelfml
  qonbllojmloykjqe
  sllkzqujfnbauuqp
  auexjwsvphvikali
  usuelbssqmbrkxyc
  wyuokkfjexikptvv
  wmfedauwjgbrgytl
  sfwvtlzzebxzmuvw
  rdhqxuechjsjcvaf
  kpavhqkukugocsxu
  ovnjtumxowbxduts
  zgerpjufauptxgat
  pevvnzjfwhjxdoxq
  pmmfwxajgfziszcs
  difmeqvaghuitjhs
  icpwjbzcmlcterwm
  ngqpvhajttxuegyh
  mosjlqswdngwqsmi
  frlvgpxrjolgodlu
  eazwgrpcxjgoszeg
  bbtsthgkjrpkiiyk
  tjonoglufuvsvabe
  xhkbcrofytmbzrtk
  kqftfzdmpbxjynps
  kmeqpocbnikdtfyv
  qjjymgqxhnjwxxhp
  dmgicrhgbngdtmjt
  zdxrhdhbdutlawnc
  afvoekuhdboxghvx
  hiipezngkqcnihty
  bbmqgheidenweeov
  suprgwxgxwfsgjnx
  adeagikyamgqphrj
  zzifqinoeqaorjxg
  adhgppljizpaxzld
  lvxyieypvvuqjiyc
  nljoakatwwwoovzn
  fcrkfxclcacshhmx
  ownnxqtdhqbgthch
  lmfylrcdmdkgpwnj
  hlwjfbvlswbzpbjr
  mkofhdtljdetcyvp
  synyxhifbetzarpo
  agnggugngadrcxoc
  uhttadmdmhidpyjw
  ohfwjfhunalbubpr
  pzkkkkwrlvxiuysn
  kmidbxmyzkjrwjhu
  egtitdydwjxmajnw
  civoeoiuwtwgbqqs
  dfptsguzfinqoslk
  tdfvkreormspprer
  zvnvbrmthatzztwi
  ffkyddccrrfikjde
  hrrmraevdnztiwff
  qaeygykcpbtjwjbr
  purwhitkmrtybslh
  qzziznlswjaussel
  dfcxkvdpqccdqqxj
  tuotforulrrytgyn
  gmtgfofgucjywkev
  wkyoxudvdkbgpwhd
  qbvktvfvipftztnn
  otckgmojziezmojb
  inxhvzbtgkjxflay
  qvxapbiatuudseno
  krpvqosbesnjntut
  oqeukkgjsfuqkjbb
  prcjnyymnqwqksiz
  vuortvjxgckresko
  orqlyobvkuwgathr
  qnpyxlnazyfuijox
  zwlblfkoklqmqzkw
  hmwurwtpwnrcsanl
  jzvxohuakopuzgpf
  sfcpnxrviphhvxmx
  qtwdeadudtqhbely
  dbmkmloasqphnlgj
  olylnjtkxgrubmtk
  nxsdbqjuvwrrdbpq
  wbabpirnpcsmpipw
  hjnkyiuxpqrlvims
  enzpntcjnxdpuqch
  vvvqhlstzcizyimn
  triozhqndbttglhv
  fukvgteitwaagpzx
  uhcvukfbmrvskpen
  tizcyupztftzxdmt
  vtkpnbpdzsaluczz
  wodfoyhoekidxttm
  otqocljrmwfqbxzu
  linfbsnfvixlwykn
  vxsluutrwskslnye
  zbshygtwugixjvsi
  zdcqwxvwytmzhvoo
  wrseozkkcyctrmei
  fblgtvogvkpqzxiy
  opueqnuyngegbtnf
  qxbovietpacqqxok
  zacrdrrkohfygddn
  gbnnvjqmkdupwzpq
  qgrgmsxeotozvcak
  hnppukzvzfmlokid
  dzbheurndscrrtcl
  wbgdkadtszebbrcw
  fdmzppzphhpzyuiz
  bukomunhrjrypohj
  ohodhelegxootqbj
  rsplgzarlrknqjyh
  punjjwpsxnhpzgvu
  djdfahypfjvpvibm
  mlgrqsmhaozatsvy
  xwktrgyuhqiquxgn
  wvfaoolwtkbrisvf
  plttjdmguxjwmeqr
  zlvvbwvlhauyjykw
  cigwkbyjhmepikej
  masmylenrusgtyxs
  hviqzufwyetyznze
  nzqfuhrooswxxhus
  pdbdetaqcrqzzwxf
  oehmvziiqwkzhzib
  icgpyrukiokmytoy
  ooixfvwtiafnwkce
  rvnmgqggpjopkihs
  wywualssrmaqigqk
  pdbvflnwfswsrirl
  jeaezptokkccpbuj
  mbdwjntysntsaaby
  ldlgcawkzcwuxzpz
  lwktbgrzswbsweht
  ecspepmzarzmgpjm
  qmfyvulkmkxjncai
  izftypvwngiukrns
  zgmnyjfeqffbooww
  nyrkhggnprhedows
  yykzzrjmlevgffah
  mavaemfxhlfejfki
  cmegmfjbkvpncqwf
  zxidlodrezztcrij
  fseasudpgvgnysjv
  fupcimjupywzpqzp
  iqhgokavirrcvyys
  wjmkcareucnmfhui
  nftflsqnkgjaexhq
  mgklahzlcbapntgw
  kfbmeavfxtppnrxn
  nuhyvhknlufdynvn
  nviogjxbluwrcoec
  tyozixxxaqiuvoys
  kgwlvmvgtsvxojpr
  moeektyhyonfdhrb
  kahvevmmfsmiiqex
  xcywnqzcdqtvhiwd
  fnievhiyltbvtvem
  jlmndqufirwgtdxd
  muypbfttoeelsnbs
  rypxzbnujitfwkou
  ubmmjbznskildeoj
  ofnmizdeicrmkjxp
  rekvectjbmdnfcib
  yohrojuvdexbctdh
  gwfnfdeibynzjmhz
  jfznhfcqdwlpjull
  scrinzycfhwkmmso
  mskutzossrwoqqsi
  rygoebkzgyzushhr
  jpjqiycflqkexemx
  arbufysjqmgaapnl
  dbjerflevtgweeoj
  snybnnjlmwjvhois
  fszuzplntraprmbj
  mkvaatolvuggikvg
  zpuzuqygoxesnuyc
  wnpxvmxvllxalulm
  eivuuafkvudeouwy
  rvzckdyixetfuehr
  qgmnicdoqhveahyx
  miawwngyymshjmpj
  pvckyoncpqeqkbmx
  llninfenrfjqxurv
  kzbjnlgsqjfuzqtp
  rveqcmxomvpjcwte
  bzotkawzbopkosnx
  ktqvpiribpypaymu
  wvlzkivbukhnvram
  uohntlcoguvjqqdo
  ajlsiksjrcnzepkt
  xsqatbldqcykwusd
  ihbivgzrwpmowkop
  vfayesfojmibkjpb
  uaqbnijtrhvqxjtb
  hhovshsfmvkvymba
  jerwmyxrfeyvxcgg
  hncafjwrlvdcupma
  qyvigggxfylbbrzt
  hiiixcyohmvnkpgk
  mmitpwopgxuftdfu
  iaxderqpceboixoa
  zodfmjhuzhnsqfcb
  sthtcbadrclrazsi
  bkkkkcwegvypbrio
  wmpcofuvzemunlhj
  gqwebiifvqoeynro
  juupusqdsvxcpsgv
  rbhdfhthxelolyse
  kjimpwnjfrqlqhhz
  rcuigrjzarzpjgfq
  htxcejfyzhydinks
  sxucpdxhvqjxxjwf
  omsznfcimbcwaxal
  gufmtdlhgrsvcosb
  bssshaqujtmluerz
  uukotwjkstgwijtr
  kbqkneobbrdogrxk
  ljqopjcjmelgrakz
  rwtfnvnzryujwkfb
  dedjjbrndqnilbeh
  nzinsxnpptzagwlb
  lwqanydfirhnhkxy
  hrjuzfumbvfccxno
  okismsadkbseumnp
  sfkmiaiwlktxqvwa
  hauwpjjwowbunbjj
  nowkofejwvutcnui
  bqzzppwoslaeixro
  urpfgufwbtzenkpj
  xgeszvuqwxeykhef
  yxoldvkyuikwqyeq
  onbbhxrnmohzskgg
  qcikuxakrqeugpoa
  lnudcqbtyzhlpers
  nxduvwfrgzaailgl
  xniuwvxufzxjjrwz
  ljwithcqmgvntjdj
  awkftfagrfzywkhs
  uedtpzxyubeveuek
  bhcqdwidbjkqqhzl
  iyneqjdmlhowwzxx
  kvshzltcrrururty
  zgfpiwajegwezupo
  tkrvyanujjwmyyri
  ercsefuihcmoaiep
  ienjrxpmetinvbos
  jnwfutjbgenlipzq
  bgohjmrptfuamzbz
  rtsyamajrhxbcncw
  tfjdssnmztvbnscs
  bgaychdlmchngqlp
  kfjljiobynhwfkjo
  owtdxzcpqleftbvn
  ltjtimxwstvzwzjj
  wbrvjjjajuombokf
  zblpbpuaqbkvsxye
  gwgdtbpnlhyqspdi
  abipqjihjqfofmkx
  nlqymnuvjpvvgova
  avngotmhodpoufzn
  qmdyivtzitnrjuae
  xfwjmqtqdljuerxi
  csuellnlcyqaaamq
  slqyrcurcyuoxquo
  dcjmxyzbzpohzprl
  uqfnmjwniyqgsowb
  rbmxpqoblyxdocqc
  ebjclrdbqjhladem
  ainnfhxnsgwqnmyo
  eyytjjwhvodtzquf
  iabjgmbbhilrcyyp
  pqfnehkivuelyccc
  xgjbyhfgmtseiimt
  jwxyqhdbjiqqqeyy
  gxsbrncqkmvaryln
  vhjisxjkinaejytk
  seexagcdmaedpcvh
  lvudfgrcpjxzdpvd
  fxtegyrqjzhmqean
  dnoiseraqcoossmc
  nwrhmwwbykvwmgep
  udmzskejvizmtlce
  hbzvqhvudfdlegaa
  cghmlfqejbxewskv
  bntcmjqfwomtbwsb
  qezhowyopjdyhzng
  todzsocdkgfxanbz
  zgjkssrjlwxuhwbk
  eibzljqsieriyrzr
  wamxvzqyycrxotjp
  epzvfkispwqynadu
  dwlpfhtrafrxlyie
  qhgzujhgdruowoug
  girstvkahaemmxvh
  baitcrqmxhazyhbl
  xyanqcchbhkajdmc
  gfvjmmcgfhvgnfdq
  tdfdbslwncbnkzyz
  jojuselkpmnnbcbb
  hatdslkgxtqpmavj
  dvelfeddvgjcyxkj
  gnsofhkfepgwltse
  mdngnobasfpewlno
  qssnbcyjgmkyuoga
  glvcmmjytmprqwvn
  gwrixumjbcdffsdl
  lozravlzvfqtsuiq
  sicaflbqdxbmdlch
  inwfjkyyqbwpmqlq
  cuvszfotxywuzhzi
  igfxyoaacoarlvay
  ucjfhgdmnjvgvuni
  rvvkzjsytqgiposh
  jduinhjjntrmqroz
  yparkxbgsfnueyll
  lyeqqeisxzfsqzuj
  woncskbibjnumydm
  lltucklragtjmxtl
  ubiyvmyhlesfxotj
  uecjseeicldqrqww
  xxlxkbcthufnjbnm
  lhqijovvhlffpxga
  fzdgqpzijitlogjz
  efzzjqvwphomxdpd
  jvgzvuyzobeazssc
  hejfycgxywfjgbfw
  yhjjmvkqfbnbliks
  sffvfyywtlntsdsz
  dwmxqudvxqdenrur
  asnukgppdemxrzaz
  nwqfnumblwvdpphx
  kqsmkkspqvxzuket
  cpnraovljzqiquaz
  qrzgrdlyyzbyykhg
  opoahcbiydyhsmqe
  hjknnfdauidjeydr
  hczdjjlygoezadow
  rtflowzqycimllfv
  sfsrgrerzlnychhq
  bpahuvlblcolpjmj
  albgnjkgmcrlaicl
  pijyqdhfxpaxzdex
  eeymiddvcwkpbpux
  rqwkqoabywgggnln
  vckbollyhgbgmgwh
  ylzlgvnuvpynybkm
  hpmbxtpfosbsjixt
  ocebeihnhvkhjfqz
  tvctyxoujdgwayze
  efvhwxtuhapqxjen
  rusksgefyidldmpo
  nkmtjvddfmhirmzz
  whvtsuadwofzmvrt
  iiwjqvsdxudhdzzk
  gucirgxaxgcassyo
  rmhfasfzexeykwmr
  hynlxcvsbgosjbis
  huregszrcaocueen
  pifezpoolrnbdqtv
  unatnixzvdbqeyox
  xtawlpduxgacchfe
  bdvdbflqfphndduf
  xtdsnjnmzccfptyt
  nkhsdkhqtzqbphhg
  aqcubmfkczlaxiyb
  moziflxpsfubucmv
  srdgnnjtfehiimqx
  pwfalehdfyykrohf
  sysxssmvewyfjrve
  brsemdzosgqvvlxe
  bimbjoshuvflkiat
  hkgjasmljkpkwwku
  sbnmwjvodygobpqc
  bbbqycejueruihhd
  corawswvlvneipyc
  gcyhknmwsczcxedh
  kppakbffdhntmcqp
  ynulzwkfaemkcefp
  pyroowjekeurlbii
  iwksighrswdcnmxf
  glokrdmugreygnsg
  xkmvvumnfzckryop
  aesviofpufygschi
  csloawlirnegsssq
  fkqdqqmlzuxbkzbc
  uzlhzcfenxdfjdzp
  poaaidrktteusvyf
  zrlyfzmjzfvivcfr
  qwjulskbniitgqtx
  gjeszjksbfsuejki
  vczdejdbfixbduaq
  knjdrjthitjxluth
  jweydeginrnicirl
  bottrfgccqhyycsl
  eiquffofoadmbuhk
  lbqfutmzoksscswf
  xfmdvnvfcnzjprba
  uvugkjbkhlaoxmyx
  wadlgtpczgvcaqqv
  inzrszbtossflsxk
  dbzbtashaartczrj
  qbjiqpccefcfkvod
  hluujmokjywotvzy
  thwlliksfztcmwzh
  arahybspdaqdexrq
  nuojrmsgyipdvwyx
  hnajdwjwmzattvst
  sulcgaxezkprjbgu
  rjowuugwdpkjtypw
  oeugzwuhnrgiaqga
  wvxnyymwftfoswij
  pqxklzkjpcqscvde
  tuymjzknntekglqj
  odteewktugcwlhln
  exsptotlfecmgehc
  eeswfcijtvzgrqel
  vjhrkiwmunuiwqau
  zhlixepkeijoemne
  pavfsmwesuvebzdd
  jzovbklnngfdmyws
  nbajyohtzfeoiixz
  ciozmhrsjzrwxvhz
  gwucrxieqbaqfjuv
  uayrxrltnohexawc
  flmrbhwsfbcquffm
  gjyabmngkitawlxc
  rwwtggvaygfbovhg
  xquiegaisynictjq
  oudzwuhexrwwdbyy
  lengxmguyrwhrebb
  uklxpglldbgqsjls
  dbmvlfeyguydfsxq
  zspdwdqcrmtmdtsc
  mqfnzwbfqlauvrgc
  amcrkzptgacywvhv
  ndxmskrwrqysrndf
  mwjyhsufeqhwisju
  srlrukoaenyevykt
  tnpjtpwawrxbikct
  geczalxmgxejulcv
  tvkcbqdhmuwcxqci
  tiovluvwezwwgaox
  zrjhtbgajkjqzmfo
  vcrywduwsklepirs
  lofequdigsszuioy
  wxsdzomkjqymlzat
  iabaczqtrfbmypuy
  ibdlmudbajikcncr
  rqcvkzsbwmavdwnv
  ypxoyjelhllhbeog
  fdnszbkezyjbttbg
  uxnhrldastpdjkdz
  xfrjbehtxnlyzcka
  omjyfhbibqwgcpbv
  eguucnoxaoprszmp
  xfpypldgcmcllyzz
  aypnmgqjxjqceelv
  mgzharymejlafvgf
  tzowgwsubbaigdok
  ilsehjqpcjwmylxc
  pfmouwntfhfnmrwk
  csgokybgdqwnduwp
  eaxwvxvvwbrovypz
  nmluqvobbbmdiwwb
  lnkminvfjjzqbmio
  mjiiqzycqdhfietz
  towlrzriicyraevq
  obiloewdvbrsfwjo
  lmeooaajlthsfltw
  ichygipzpykkesrw
  gfysloxmqdsfskvt
  saqzntehjldvwtsx
  pqddoemaufpfcaew
  mjrxvbvwcreaybwe
  ngfbrwfqnxqosoai
  nesyewxreiqvhald
  kqhqdlquywotcyfy
  liliptyoqujensfi
  nsahsaxvaepzneqq
  zaickulfjajhctye
  gxjzahtgbgbabtht
  koxbuopaqhlsyhrp
  jhzejdjidqqtjnwe
  dekrkdvprfqpcqki
  linwlombdqtdeyop
  dvckqqbnigdcmwmx
  yaxygbjpzkvnnebv
  rlzkdkgaagmcpxah
  cfzuyxivtknirqvt
  obivkajhsjnrxxhn
  lmjhayymgpseuynn
  bbjyewkwadaipyju
  lmzyhwomfypoftuu
  gtzhqlgltvatxack
  jfflcfaqqkrrltgq
  txoummmnzfrlrmcg
  ohemsbfuqqpucups
  imsfvowcbieotlok
  tcnsnccdszxfcyde
  qkcdtkwuaquajazz
  arcfnhmdjezdbqku
  srnocgyqrlcvlhkb
  mppbzvfmcdirbyfw
  xiuarktilpldwgwd
  ypufwmhrvzqmexpc
  itpdnsfkwgrdujmj
  cmpxnodtsswkyxkr
  wayyxtjklfrmvbfp
  mfaxphcnjczhbbwy
  sjxhgwdnqcofbdra
  pnxmujuylqccjvjm
  ivamtjbvairwjqwl
  deijtmzgpfxrclss
  bzkqcaqagsynlaer
  tycefobvxcvwaulz
  ctbhnywezxkdsswf
  urrxxebxrthtjvib
  fpfelcigwqwdjucv
  ngfcyyqpqulwcphb
  rltkzsiipkpzlgpw
  qfdsymzwhqqdkykc
  balrhhxipoqzmihj
  rnwalxgigswxomga
  ghqnxeogckshphgr
  lyyaentdizaumnla
  exriodwfzosbeoib
  speswfggibijfejk
  yxmxgfhvmshqszrq
  hcqhngvahzgawjga
  qmhlsrfpesmeksur
  eviafjejygakodla
  kvcfeiqhynqadbzv
  fusvyhowslfzqttg
  girqmvwmcvntrwau
  yuavizroykfkdekz
  jmcwohvmzvowrhxf
  kzimlcpavapynfue
  wjudcdtrewfabppq
  yqpteuxqgbmqfgxh
  xdgiszbuhdognniu
  jsguxfwhpftlcjoh
  whakkvspssgjzxre
  ggvnvjurlyhhijgm
  krvbhjybnpemeptr
  pqedgfojyjybfbzr
  jzhcrsgmnkwwtpdo
  yyscxoxwofslncmp
  gzjhnxytmyntzths
  iteigbnqbtpvqumi
  zjevfzusnjukqpfw
  xippcyhkfuounxqk
  mcnhrcfonfdgpkyh
  pinkcyuhjkexbmzj
  lotxrswlxbxlxufs
  fmqajrtoabpckbnu
  wfkwsgmcffdgaqxg
  qfrsiwnohoyfbidr
  czfqbsbmiuyusaqs
  ieknnjeecucghpoo
  cevdgqnugupvmsge
  gjkajcyjnxdrtuvr
  udzhrargnujxiclq
  zqqrhhmjwermjssg
  ggdivtmgoqajydzz
  wnpfsgtxowkjiivl
  afbhqawjbotxnqpd
  xjpkifkhfjeqifdn
  oyfggzsstfhvticp
  kercaetahymeawxy
  khphblhcgmbupmzt
  iggoqtqpvaebtiol
  ofknifysuasshoya
  qxuewroccsbogrbv
  apsbnbkiopopytgu
  zyahfroovfjlythh
  bxhjwfgeuxlviydq
  uvbhdtvaypasaswa
  qamcjzrmesqgqdiz
  hjnjyzrxntiycyel
  wkcrwqwniczwdxgq
  hibxlvkqakusswkx
  mzjyuenepwdgrkty
  tvywsoqslfsulses
  jqwcwuuisrclircv
  xanwaoebfrzhurct
  ykriratovsvxxasf
  qyebvtqqxbjuuwuo
  telrvlwvriylnder
  acksrrptgnhkeiaa
  yemwfjhiqlzsvdxf
  banrornfkcymmkcc
  ytbhxvaeiigjpcgm
  crepyazgxquposkn
  xlqwdrytzwnxzwzv
  xtrbfbwopxscftps
  kwbytzukgseeyjla
  qtfdvavvjogybxjg
  ytbmvmrcxwfkgvzw
  nbscbdskdeocnfzr
  sqquwjbdxsxhcseg
  ewqxhigqcgszfsuw
  cvkyfcyfmubzwsee
  dcoawetekigxgygd
  ohgqnqhfimyuqhvi
  otisopzzpvnhctte
  bauieohjejamzien
  ewnnopzkujbvhwce
  aeyqlskpaehagdiv
  pncudvivwnnqspxy
  ytugesilgveokxcg
  zoidxeelqdjesxpr
  ducjccsuaygfchzj
  smhgllqqqcjfubfc
  nlbyyywergronmir
  prdawpbjhrzsbsvj
  nmgzhnjhlpcplmui
  eflaogtjghdjmxxz
  qolvpngucbkprrdc
  ixywxcienveltgho
  mwnpqtocagenkxut
  iskrfbwxonkguywx
  ouhtbvcaczqzmpua
  srewprgddfgmdbao
  dyufrltacelchlvu
  czmzcbrkecixuwzz
  dtbeojcztzauofuk
  prrgoehpqhngfgmw
  baolzvfrrevxsyke
  zqadgxshwiarkzwh
  vsackherluvurqqj
  surbpxdulvcvgjbd
  wqxytarcxzgxhvtx
  vbcubqvejcfsgrac
  zqnjfeapshjowzja
  hekvbhtainkvbynx
  knnugxoktxpvoxnh
  knoaalcefpgtvlwm
  qoakaunowmsuvkus
  ypkvlzcduzlezqcb
  ujhcagawtyepyogh
  wsilcrxncnffaxjf
  gbbycjuscquaycrk
  aduojapeaqwivnly
  ceafyxrakviagcjy
  nntajnghicgnrlst
  vdodpeherjmmvbje
  wyyhrnegblwvdobn
  xlfurpghkpbzhhif
  xyppnjiljvirmqjo
  kglzqahipnddanpi
  omjateouxikwxowr
  ocifnoopfglmndcx
  emudcukfbadyijev
  ooktviixetfddfmh
  wtvrhloyjewdeycg
  cgjncqykgutfjhvb
  nkwvpswppeffmwad
  hqbcmfhzkxmnrivg
  mdskbvzguxvieilr
  anjcvqpavhdloaqh
  erksespdevjylenq
  fadxwbmisazyegup
  iyuiffjmcaahowhj
  ygkdezmynmltodbv
  fytneukxqkjattvh
  woerxfadbfrvdcnz
  iwsljvkyfastccoa
  movylhjranlorofe
  drdmicdaiwukemep
  knfgtsmuhfcvvshg
  ibstpbevqmdlhajn
  tstwsswswrxlzrqs
  estyydmzothggudf
  jezogwvymvikszwa
  izmqcwdyggibliet
  nzpxbegurwnwrnca
  kzkojelnvkwfublh
  xqcssgozuxfqtiwi
  tcdoigumjrgvczfv
  ikcjyubjmylkwlwq
  kqfivwystpqzvhan
  bzukgvyoqewniivj
  iduapzclhhyfladn
  fbpyzxdfmkrtfaeg
  yzsmlbnftftgwadz
  """
  end

  def day6_input do
  """
  turn off 660,55 through 986,197
  turn off 341,304 through 638,850
  turn off 199,133 through 461,193
  toggle 322,558 through 977,958
  toggle 537,781 through 687,941
  turn on 226,196 through 599,390
  turn on 240,129 through 703,297
  turn on 317,329 through 451,798
  turn on 957,736 through 977,890
  turn on 263,530 through 559,664
  turn on 158,270 through 243,802
  toggle 223,39 through 454,511
  toggle 544,218 through 979,872
  turn on 313,306 through 363,621
  toggle 173,401 through 496,407
  toggle 333,60 through 748,159
  turn off 87,577 through 484,608
  turn on 809,648 through 826,999
  toggle 352,432 through 628,550
  turn off 197,408 through 579,569
  turn off 1,629 through 802,633
  turn off 61,44 through 567,111
  toggle 880,25 through 903,973
  turn on 347,123 through 864,746
  toggle 728,877 through 996,975
  turn on 121,895 through 349,906
  turn on 888,547 through 931,628
  toggle 398,782 through 834,882
  turn on 966,850 through 989,953
  turn off 891,543 through 914,991
  toggle 908,77 through 916,117
  turn on 576,900 through 943,934
  turn off 580,170 through 963,206
  turn on 184,638 through 192,944
  toggle 940,147 through 978,730
  turn off 854,56 through 965,591
  toggle 717,172 through 947,995
  toggle 426,987 through 705,998
  turn on 987,157 through 992,278
  toggle 995,774 through 997,784
  turn off 796,96 through 845,182
  turn off 451,87 through 711,655
  turn off 380,93 through 968,676
  turn on 263,468 through 343,534
  turn on 917,936 through 928,959
  toggle 478,7 through 573,148
  turn off 428,339 through 603,624
  turn off 400,880 through 914,953
  toggle 679,428 through 752,779
  turn off 697,981 through 709,986
  toggle 482,566 through 505,725
  turn off 956,368 through 993,516
  toggle 735,823 through 783,883
  turn off 48,487 through 892,496
  turn off 116,680 through 564,819
  turn on 633,865 through 729,930
  turn off 314,618 through 571,922
  toggle 138,166 through 936,266
  turn on 444,732 through 664,960
  turn off 109,337 through 972,497
  turn off 51,432 through 77,996
  turn off 259,297 through 366,744
  toggle 801,130 through 917,544
  toggle 767,982 through 847,996
  turn on 216,507 through 863,885
  turn off 61,441 through 465,731
  turn on 849,970 through 944,987
  toggle 845,76 through 852,951
  toggle 732,615 through 851,936
  toggle 251,128 through 454,778
  turn on 324,429 through 352,539
  toggle 52,450 through 932,863
  turn off 449,379 through 789,490
  turn on 317,319 through 936,449
  toggle 887,670 through 957,838
  toggle 671,613 through 856,664
  turn off 186,648 through 985,991
  turn off 471,689 through 731,717
  toggle 91,331 through 750,758
  toggle 201,73 through 956,524
  toggle 82,614 through 520,686
  toggle 84,287 through 467,734
  turn off 132,367 through 208,838
  toggle 558,684 through 663,920
  turn on 237,952 through 265,997
  turn on 694,713 through 714,754
  turn on 632,523 through 862,827
  turn on 918,780 through 948,916
  turn on 349,586 through 663,976
  toggle 231,29 through 257,589
  toggle 886,428 through 902,993
  turn on 106,353 through 236,374
  turn on 734,577 through 759,684
  turn off 347,843 through 696,912
  turn on 286,699 through 964,883
  turn on 605,875 through 960,987
  turn off 328,286 through 869,461
  turn off 472,569 through 980,848
  toggle 673,573 through 702,884
  turn off 398,284 through 738,332
  turn on 158,50 through 284,411
  turn off 390,284 through 585,663
  turn on 156,579 through 646,581
  turn on 875,493 through 989,980
  toggle 486,391 through 924,539
  turn on 236,722 through 272,964
  toggle 228,282 through 470,581
  toggle 584,389 through 750,761
  turn off 899,516 through 900,925
  turn on 105,229 through 822,846
  turn off 253,77 through 371,877
  turn on 826,987 through 906,992
  turn off 13,152 through 615,931
  turn on 835,320 through 942,399
  turn on 463,504 through 536,720
  toggle 746,942 through 786,998
  turn off 867,333 through 965,403
  turn on 591,477 through 743,692
  turn off 403,437 through 508,908
  turn on 26,723 through 368,814
  turn on 409,485 through 799,809
  turn on 115,630 through 704,705
  turn off 228,183 through 317,220
  toggle 300,649 through 382,842
  turn off 495,365 through 745,562
  turn on 698,346 through 744,873
  turn on 822,932 through 951,934
  toggle 805,30 through 925,421
  toggle 441,152 through 653,274
  toggle 160,81 through 257,587
  turn off 350,781 through 532,917
  toggle 40,583 through 348,636
  turn on 280,306 through 483,395
  toggle 392,936 through 880,955
  toggle 496,591 through 851,934
  turn off 780,887 through 946,994
  turn off 205,735 through 281,863
  toggle 100,876 through 937,915
  turn on 392,393 through 702,878
  turn on 956,374 through 976,636
  toggle 478,262 through 894,775
  turn off 279,65 through 451,677
  turn on 397,541 through 809,847
  turn on 444,291 through 451,586
  toggle 721,408 through 861,598
  turn on 275,365 through 609,382
  turn on 736,24 through 839,72
  turn off 86,492 through 582,712
  turn on 676,676 through 709,703
  turn off 105,710 through 374,817
  toggle 328,748 through 845,757
  toggle 335,79 through 394,326
  toggle 193,157 through 633,885
  turn on 227,48 through 769,743
  toggle 148,333 through 614,568
  toggle 22,30 through 436,263
  toggle 547,447 through 688,969
  toggle 576,621 through 987,740
  turn on 711,334 through 799,515
  turn on 541,448 through 654,951
  toggle 792,199 through 798,990
  turn on 89,956 through 609,960
  toggle 724,433 through 929,630
  toggle 144,895 through 201,916
  toggle 226,730 through 632,871
  turn off 760,819 through 828,974
  toggle 887,180 through 940,310
  toggle 222,327 through 805,590
  turn off 630,824 through 885,963
  turn on 940,740 through 954,946
  turn on 193,373 through 779,515
  toggle 304,955 through 469,975
  turn off 405,480 through 546,960
  turn on 662,123 through 690,669
  turn off 615,238 through 750,714
  turn on 423,220 through 930,353
  turn on 329,769 through 358,970
  toggle 590,151 through 704,722
  turn off 884,539 through 894,671
  toggle 449,241 through 984,549
  toggle 449,260 through 496,464
  turn off 306,448 through 602,924
  turn on 286,805 through 555,901
  toggle 722,177 through 922,298
  toggle 491,554 through 723,753
  turn on 80,849 through 174,996
  turn off 296,561 through 530,856
  toggle 653,10 through 972,284
  toggle 529,236 through 672,614
  toggle 791,598 through 989,695
  turn on 19,45 through 575,757
  toggle 111,55 through 880,871
  turn off 197,897 through 943,982
  turn on 912,336 through 977,605
  toggle 101,221 through 537,450
  turn on 101,104 through 969,447
  toggle 71,527 through 587,717
  toggle 336,445 through 593,889
  toggle 214,179 through 575,699
  turn on 86,313 through 96,674
  toggle 566,427 through 906,888
  turn off 641,597 through 850,845
  turn on 606,524 through 883,704
  turn on 835,775 through 867,887
  toggle 547,301 through 897,515
  toggle 289,930 through 413,979
  turn on 361,122 through 457,226
  turn on 162,187 through 374,746
  turn on 348,461 through 454,675
  turn off 966,532 through 985,537
  turn on 172,354 through 630,606
  turn off 501,880 through 680,993
  turn off 8,70 through 566,592
  toggle 433,73 through 690,651
  toggle 840,798 through 902,971
  toggle 822,204 through 893,760
  turn off 453,496 through 649,795
  turn off 969,549 through 990,942
  turn off 789,28 through 930,267
  toggle 880,98 through 932,434
  toggle 568,674 through 669,753
  turn on 686,228 through 903,271
  turn on 263,995 through 478,999
  toggle 534,675 through 687,955
  turn off 342,434 through 592,986
  toggle 404,768 through 677,867
  toggle 126,723 through 978,987
  toggle 749,675 through 978,959
  turn off 445,330 through 446,885
  turn off 463,205 through 924,815
  turn off 417,430 through 915,472
  turn on 544,990 through 912,999
  turn off 201,255 through 834,789
  turn off 261,142 through 537,862
  turn off 562,934 through 832,984
  turn off 459,978 through 691,980
  turn off 73,911 through 971,972
  turn on 560,448 through 723,810
  turn on 204,630 through 217,854
  turn off 91,259 through 611,607
  turn on 877,32 through 978,815
  turn off 950,438 through 974,746
  toggle 426,30 through 609,917
  toggle 696,37 through 859,201
  toggle 242,417 through 682,572
  turn off 388,401 through 979,528
  turn off 79,345 through 848,685
  turn off 98,91 through 800,434
  toggle 650,700 through 972,843
  turn off 530,450 through 538,926
  turn on 428,559 through 962,909
  turn on 78,138 through 92,940
  toggle 194,117 through 867,157
  toggle 785,355 through 860,617
  turn off 379,441 through 935,708
  turn off 605,133 through 644,911
  toggle 10,963 through 484,975
  turn off 359,988 through 525,991
  turn off 509,138 through 787,411
  toggle 556,467 through 562,773
  turn on 119,486 through 246,900
  turn on 445,561 through 794,673
  turn off 598,681 through 978,921
  turn off 974,230 through 995,641
  turn off 760,75 through 800,275
  toggle 441,215 through 528,680
  turn off 701,636 through 928,877
  turn on 165,753 through 202,780
  toggle 501,412 through 998,516
  toggle 161,105 through 657,395
  turn on 113,340 through 472,972
  toggle 384,994 through 663,999
  turn on 969,994 through 983,997
  turn on 519,600 through 750,615
  turn off 363,899 through 948,935
  turn on 271,845 through 454,882
  turn off 376,528 through 779,640
  toggle 767,98 through 854,853
  toggle 107,322 through 378,688
  turn off 235,899 through 818,932
  turn on 445,611 through 532,705
  toggle 629,387 through 814,577
  toggle 112,414 through 387,421
  toggle 319,184 through 382,203
  turn on 627,796 through 973,940
  toggle 602,45 through 763,151
  turn off 441,375 through 974,545
  toggle 871,952 through 989,998
  turn on 717,272 through 850,817
  toggle 475,711 through 921,882
  toggle 66,191 through 757,481
  turn off 50,197 through 733,656
  toggle 83,575 through 915,728
  turn on 777,812 through 837,912
  turn on 20,984 through 571,994
  turn off 446,432 through 458,648
  turn on 715,871 through 722,890
  toggle 424,675 through 740,862
  toggle 580,592 through 671,900
  toggle 296,687 through 906,775
  """
  end
end
