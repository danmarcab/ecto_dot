defmodule User do
  use Ecto.Schema

  schema "users" do
    field(:first_name, :string)
    field(:surname, :string)
    field(:email, :string)

    has_many(:posts, Post, foreign_key: :author_id)
    has_many(:comments, Comment, foreign_key: :author_id)
  end
end
