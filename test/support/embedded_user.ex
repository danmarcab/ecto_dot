defmodule EmbeddedUser do
  use Ecto.Schema

  embedded_schema do
    field(:first_name, :string)
    field(:surname, :string)
    field(:email, :string)

    embeds_many(:posts, EmbeddedPost)
    embeds_many(:comments, EmbeddedComment)
  end
end
