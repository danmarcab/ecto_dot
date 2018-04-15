defmodule EctoDot.Diagram do
  @moduledoc false
  defstruct [:name, :schemas, :associations]

  alias EctoDot.Schema
  alias EctoDot.Association

  def to_dot(%__MODULE__{} = diagram) do
    schemas =
      diagram.schemas
      |> Enum.map(fn schema -> Schema.to_dot(schema, indentation: 2) end)

    associations =
      diagram.associations
      |> Enum.map(fn assoc -> Association.to_dot(assoc, indentation: 2) end)

    body =
      [schemas, associations]
      |> Enum.reject(&Enum.empty?/1)
      |> Enum.map(&Enum.join(&1, "\n"))
      |> Enum.join("\n\n")

    ~s"""
    digraph "#{diagram.name}" {
    #{body}
    }
    """
  end
end
