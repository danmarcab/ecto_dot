defmodule Comment do
  use Ecto.Schema

  schema "comments" do
    field(:title, :string)
    field(:body, :string)

    belongs_to(:author, User)
    belongs_to(:post, Post)
  end
end
