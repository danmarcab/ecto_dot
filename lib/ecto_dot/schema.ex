defmodule EctoDot.Schema do
  @moduledoc false
  alias EctoDot.Field

  defstruct [:mod, :name, :fields]

  def from_ecto(mod) do
    fields =
      mod.__schema__(:fields)
      |> Enum.map(fn field ->
        %Field{name: field, type: mod.__schema__(:type, field)}
      end)

    %__MODULE__{mod: mod, name: Macro.to_string(mod), fields: fields}
  end

  def to_dot(%__MODULE__{} = schema, opts \\ []) do
    indent = String.duplicate(" ", Keyword.get(opts, :indentation, 0))

    fields =
      schema.fields
      |> Enum.map(&Field.to_dot/1)
      |> Enum.map(fn field -> field <> "\\l" end)

    ~s(#{indent}"#{schema.name}" [shape="record", label="{#{schema.name}|#{fields}}"])
  end
end
