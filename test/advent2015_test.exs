defmodule Advent2015Test do
  use ExUnit.Case
  doctest Advent2015

_ = """
  test "greets the world" do
    assert Advent2015.hello() == :world
  end

  test "day 1" do
    assert Advent2015.follow("(())") == 0
    assert Advent2015.follow("()()") == 0
    assert Advent2015.follow("(((") == 3
    assert Advent2015.follow("(()(()(") == 3
    assert Advent2015.follow("))(((((") == 3
    assert Advent2015.follow("())") == -1
    assert Advent2015.follow("))(") == -1
    assert Advent2015.follow(")))") == -3
    assert Advent2015.follow(")())())") == -3
  end

  test "day 1 part 2" do
    assert Advent2015.find_basement(")") == 1
    assert Advent2015.find_basement("()())") == 5
  end

  test "day 2" do
    assert Advent2015.wrap("2x3x4") == 58
    assert Advent2015.wrap("1x1x10") == 43
  end

  test "day 2 part 2" do
    assert Advent2015.ribbon("2x3x4") == 34
    assert Advent2015.ribbon("1x1x10") == 14
  end

  test "day 3" do
    assert Advent2015.deliveries(">") == 2
    assert Advent2015.deliveries("^>v<") == 4
    assert Advent2015.deliveries("^v^v^v^v^v") == 2
  end

  test "day 3 part 2" do
    assert Advent2015.deliveries2("^v") == 3
    assert Advent2015.deliveries2("^>v<") == 3
    assert Advent2015.deliveries2("^v^v^v^v^v") == 11
  end

  test "day 4 part 1" do
    assert Advent2015.hashproducer("abcdef") == 609043
    assert Advent2015.hashproducer("pqrstuv") == 1048970
  end

  test "day 5 part 1" do
    assert Advent2015.nice?("ugknbfddgicrmopn")
    assert Advent2015.nice?("aaa")
    assert not Advent2015.nice?("jchzalrnumimnmhp")
    assert not Advent2015.nice?("haegwjzuvuyypxyu")
    assert not Advent2015.nice?("dvszwmarrgswjxmb")
  end

  test "day 5 part 2" do
    assert Advent2015.nicer?("qjhvhtzxzqqjkmpb")
    assert Advent2015.nicer?("xxyxx")
    assert not Advent2015.nicer?("uurcxstgmygtbstg")
    assert not Advent2015.nicer?("ieodomkazucvgmuy")
  end

  test "day 6 part 1" do
    assert Advent2015.lights(%{}, "turn on 0,0 through 9,9")
    |> Map.values |> Enum.filter(&(&1)) |> Enum.count == 100
    assert Advent2015.lights(%{}, "turn on 0,0 through 9,9")
    |> Advent2015.lights("turn off 0,0 through 4,4")
    |> Map.values |> Enum.filter(&(&1)) |> Enum.count == 75
  end
  """

  test "day 7 part 1" do
    input = """
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
    """ |> String.split("\n", trim: true)
    result = Advent2015.run_circuit(input)
    assert result |> Map.get("x") == 123
    assert result |> Map.get("y") == 456
    assert result |> Map.get("d") == 72
    assert result |> Map.get("e") == 507
    assert result |> Map.get("f") == 492
    assert result |> Map.get("g") == 114
    assert result |> Map.get("h") == -124
    assert result |> Map.get("i") == -457
  end
end
