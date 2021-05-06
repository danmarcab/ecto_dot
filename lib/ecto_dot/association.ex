defmodule EctoDot.Association do
  @moduledoc false
  defstruct [:name, :from, :to, :cardinality]

  def from_ecto(mod) do
    associations_and_embeds(mod)
    |> Enum.flat_map(fn assoc ->
      if is_struct(assoc, Ecto.Association.Has) || is_struct(assoc, Ecto.Embedded) do
        [
          %__MODULE__{
            name: assoc.field,
            from: mod,
            to: assoc.related,
            cardinality: assoc.cardinality
          }
        ]
      else
        []
      end
    end)
  end

  defp associations_and_embeds(mod) do
    associations = 
      mod.__schema__(:associations)
      |> Enum.map(& mod.__schema__(:association, &1))

    embeds = 
      mod.__schema__(:embeds)
      |> Enum.map(& mod.__schema__(:embed, &1))

    associations ++ embeds
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
