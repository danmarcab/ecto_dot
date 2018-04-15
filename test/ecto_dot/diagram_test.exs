defmodule EctoDot.DiagramTest do
  use ExUnit.Case
  doctest EctoDot.Schema
  alias EctoDot.Diagram
  alias EctoDot.Schema
  alias EctoDot.Association

  describe "end to end" do
    test "only one schema with no self associations" do
      expected = ~s"""
      digraph "Diagram" {
        #{Schema.from_ecto(User) |> Schema.to_dot()}
      }
      """

      assert EctoDot.diagram(User) |> Diagram.to_dot() == expected
    end

    test "only one schema with self associations" do
      expected = ~s"""
      digraph "Diagram" {
        #{Schema.from_ecto(Post) |> Schema.to_dot()}

        #{assoc_dot(Post, :related)}
      }
      """

      assert EctoDot.diagram(Post) |> Diagram.to_dot() == expected
    end

    test "many schemas" do
      expected = ~s"""
      digraph "Diagram" {
        #{Schema.from_ecto(User) |> Schema.to_dot()}
        #{Schema.from_ecto(Post) |> Schema.to_dot()}
        #{Schema.from_ecto(Comment) |> Schema.to_dot()}

        #{assoc_dot(User, :posts)}
        #{assoc_dot(User, :comments)}
        #{assoc_dot(Post, :comments)}
        #{assoc_dot(Post, :related)}
      }
      """

      assert EctoDot.diagram([User, Post, Comment]) |> Diagram.to_dot() == expected
    end
  end

  defp assoc_dot(mod, name) do
    Association.from_ecto(mod)
    |> Enum.find(fn
      %{name: ^name} -> true
      _ -> false
    end)
    |> Association.to_dot()
  end
end
