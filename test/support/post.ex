defmodule Post do
  use Ecto.Schema

  schema "posts" do
    field(:title, :string)
    field(:body, :string)

    belongs_to(:author, User)
    has_many(:comments, Comment)
    has_many(:related, Post)
  end
end
