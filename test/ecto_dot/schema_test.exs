defmodule EctoDot.SchemaTest do
  use ExUnit.Case
  doctest EctoDot.Schema
  alias EctoDot.Schema

  test "end to end" do
    expected =
      ~s("User" [shape="record", label="{User|id: id\\lfirst_name: string\\lsurname: string\\lemail: string\\l}"])

    assert Schema.from_ecto(User) |> Schema.to_dot() == expected
  end

  test "end to end for embedded schemas" do
    expected =
      ~s("EmbeddedUser" [shape="record", label="{EmbeddedUser|id: binary_id\\lfirst_name: string\\lsurname: string\\lemail: string\\l}"])

    assert Schema.from_ecto(EmbeddedUser) |> Schema.to_dot() == expected
  end
end
