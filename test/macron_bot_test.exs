defmodule MacronBotTest do
  use ExUnit.Case
  doctest MacronBot

  test "greets the world" do
    assert MacronBot.hello() == :world
  end
end
