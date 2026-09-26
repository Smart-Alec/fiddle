defmodule FiddleTest do
  use ExUnit.Case
  doctest Fiddle

  test "greets the world" do
    assert Fiddle.hello() == :world
  end
end
