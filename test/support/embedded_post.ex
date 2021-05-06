defmodule EmbeddedPost do
  use Ecto.Schema

  embedded_schema do
    field(:title, :string)
    field(:body, :string)

    embeds_many(:comments, EmbeddedComment)
    embeds_many(:related, EmbeddedPost)
    belongs_to(:author, EmbeddedUser)
  end
end
