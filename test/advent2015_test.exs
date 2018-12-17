defmodule Advent2015Test do
  use ExUnit.Case
  doctest Advent2015

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
end
