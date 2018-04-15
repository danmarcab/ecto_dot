defmodule EctoDotTest do
  use ExUnit.Case
  doctest EctoDot
  alias EctoDot.Schema
  alias EctoDot.Association

  describe "diagram" do
    test "one module with no self associations" do
      diag = EctoDot.diagram(User)

      assert diag.name == "Diagram"
      assert diag.schemas == [Schema.from_ecto(User)]
      assert diag.associations == []
    end

    test "one module with self associations" do
      diag = EctoDot.diagram(Post)

      assert diag.name == "Diagram"
      assert diag.schemas == [Schema.from_ecto(Post)]

      assert diag.associations == [
               %Association{name: :related, from: Post, to: Post, cardinality: :many}
             ]
    end

    test "many modules with no self associations" do
      diag = EctoDot.diagram([User, Comment])

      assert diag.name == "Diagram"
      assert diag.schemas == [Schema.from_ecto(User), Schema.from_ecto(Comment)]

      assert diag.associations == [
               %Association{name: :comments, from: User, to: Comment, cardinality: :many}
             ]
    end

    test "many modules with self associations" do
      diag = EctoDot.diagram([User, Post])

      assert diag.name == "Diagram"
      assert diag.schemas == [Schema.from_ecto(User), Schema.from_ecto(Post)]

      assert diag.associations == [
               %Association{name: :posts, from: User, to: Post, cardinality: :many},
               %Association{name: :related, from: Post, to: Post, cardinality: :many}
             ]
    end

    test "all modules" do
      diag = EctoDot.diagram([User, Post, Comment])

      assert diag.name == "Diagram"

      assert diag.schemas == [
               Schema.from_ecto(User),
               Schema.from_ecto(Post),
               Schema.from_ecto(Comment)
             ]

      assert diag.associations == [
               %Association{name: :posts, from: User, to: Post, cardinality: :many},
               %Association{name: :comments, from: User, to: Comment, cardinality: :many},
               %Association{name: :comments, from: Post, to: Comment, cardinality: :many},
               %Association{name: :related, from: Post, to: Post, cardinality: :many}
             ]
    end
  end
end
