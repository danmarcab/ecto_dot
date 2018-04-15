defmodule EctoDot.Field do
  @moduledoc false
  defstruct [:name, :type]

  def to_dot(%__MODULE__{type: type} = field) do
    pretty_type =
      case type do
        atom when is_atom(atom) -> atom
        {container, atom} when is_atom(container) and is_atom(atom) -> "#{container} of #{atom}"
        other -> inspect(other)
      end

    "#{Atom.to_string(field.name)}: #{pretty_type}"
  end
end
