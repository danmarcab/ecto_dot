defmodule EctoDot.Field do
  @moduledoc false
  defstruct [:name, :type]

  def to_dot(%__MODULE__{} = field) do
    "#{Atom.to_string(field.name)}: #{field.type}"
  end
end
