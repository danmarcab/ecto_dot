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

    test "one module with an embedded schema" do
      diag = EctoDot.diagram(EmbeddedUser)

      assert diag.name == "Diagram"
      assert diag.schemas == [Schema.from_ecto(EmbeddedUser)]
      assert diag.associations == []
    end

    test "one module with an embedded schema and self associations" do
      diag = EctoDot.diagram(EmbeddedPost)

      assert diag.name == "Diagram"
      assert diag.schemas == [Schema.from_ecto(EmbeddedPost)]

      assert diag.associations == [
               %Association{name: :related, from: EmbeddedPost, to: EmbeddedPost, cardinality: :many}
             ]
    end

    test "many modules with embedded schemas and no self associations" do
      diag = EctoDot.diagram([EmbeddedUser, EmbeddedComment])

      assert diag.name == "Diagram"
      assert diag.schemas == [Schema.from_ecto(EmbeddedUser), Schema.from_ecto(EmbeddedComment)]

      assert diag.associations == [
               %Association{name: :comments, from: EmbeddedUser, to: EmbeddedComment, cardinality: :many}
             ]
    end

    test "many modules with embedded schemas and self associations" do
      diag = EctoDot.diagram([EmbeddedUser, EmbeddedPost])

      assert diag.name == "Diagram"
      assert diag.schemas == [Schema.from_ecto(EmbeddedUser), Schema.from_ecto(EmbeddedPost)]

      assert diag.associations == [
               %Association{name: :posts, from: EmbeddedUser, to: EmbeddedPost, cardinality: :many},
               %Association{name: :related, from: EmbeddedPost, to: EmbeddedPost, cardinality: :many}
             ]
    end

    test "all modules with embedded schemas" do
      diag = EctoDot.diagram([EmbeddedUser, EmbeddedPost, EmbeddedComment])

      assert diag.name == "Diagram"

      assert diag.schemas == [
               Schema.from_ecto(EmbeddedUser),
               Schema.from_ecto(EmbeddedPost),
               Schema.from_ecto(EmbeddedComment)
             ]

      assert diag.associations == [
               %Association{name: :posts, from: EmbeddedUser, to: EmbeddedPost, cardinality: :many},
               %Association{name: :comments, from: EmbeddedUser, to: EmbeddedComment, cardinality: :many},
               %Association{name: :comments, from: EmbeddedPost, to: EmbeddedComment, cardinality: :many},
               %Association{name: :related, from: EmbeddedPost, to: EmbeddedPost, cardinality: :many}
             ]
    end
  end
end
