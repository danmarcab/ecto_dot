defmodule EmbeddedComment do
  use Ecto.Schema

  embedded_schema do
    field(:title, :string)
    field(:body, :string)

    belongs_to(:author, EmbeddedUser)
    belongs_to(:post, Post)
  end
end
