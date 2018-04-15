defmodule EctoDot.Association do
  @moduledoc false
  defstruct [:name, :from, :to, :cardinality]

  def from_ecto(mod) do
    mod.__schema__(:associations)
    |> Enum.map(fn assoc ->
      mod.__schema__(:association, assoc)
    end)
    |> Enum.flat_map(fn
      %Ecto.Association.Has{} = assoc ->
        [
          %__MODULE__{
            name: assoc.field,
            from: mod,
            to: assoc.related,
            cardinality: assoc.cardinality
          }
        ]

      _ ->
        []
    end)
  end

  def to_dot(%__MODULE__{} = assoc, opts \\ []) do
    indent = String.duplicate(" ", Keyword.get(opts, :indentation, 0))

    from = Macro.to_string(assoc.from)
    to = Macro.to_string(assoc.to)
    label = assoc.name

    arrow_tail =
      if assoc.cardinality == :many do
        "odiamond"
      else
        "none"
      end

    attrs = ~s([label="#{label}", dir="both", arrowhead="none", arrowtail="#{arrow_tail}"])
    ~s(#{indent}"#{from}" -> "#{to}" #{attrs})
  end
end
