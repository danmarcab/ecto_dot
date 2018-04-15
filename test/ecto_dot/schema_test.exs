defmodule EctoDot.SchemaTest do
  use ExUnit.Case
  doctest EctoDot.Schema
  alias EctoDot.Schema

  test "end to end" do
    expected =
      ~s(User [shape="record", label="{User|id: id\\lfirst_name: string\\lsurname: string\\lemail: string\\l}"])

    assert Schema.from_ecto(User) |> Schema.to_dot() == expected
  end
end
