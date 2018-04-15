defmodule EctoDot.AssociationTest do
  use ExUnit.Case
  doctest EctoDot.Association
  alias EctoDot.Association

  describe "end to end" do
    test "for user" do
      expected = [
        "\"User\" -> \"Post\" [label=\"posts\", dir=\"both\", arrowhead=\"none\", arrowtail=\"odiamond\"]",
        "\"User\" -> \"Comment\" [label=\"comments\", dir=\"both\", arrowhead=\"none\", arrowtail=\"odiamond\"]"
      ]

      assert Association.from_ecto(User) |> Enum.map(&Association.to_dot/1) == expected
    end

    test "for post" do
      expected = [
        "\"Post\" -> \"Comment\" [label=\"comments\", dir=\"both\", arrowhead=\"none\", arrowtail=\"odiamond\"]",
        "\"Post\" -> \"Post\" [label=\"related\", dir=\"both\", arrowhead=\"none\", arrowtail=\"odiamond\"]"
      ]

      assert Association.from_ecto(Post) |> Enum.map(&Association.to_dot/1) == expected
    end

    test "for comment" do
      expected = []

      assert Association.from_ecto(Comment) |> Enum.map(&Association.to_dot/1) == expected
    end
  end
end
