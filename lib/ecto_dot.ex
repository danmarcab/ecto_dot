defmodule EctoDot do
  @moduledoc """
  EctoDot provides an easy way to generate .dot, .png, .svg and .pdf diagrams directly from your ecto schema modules.
  """

  alias EctoDot.Schema
  alias EctoDot.Association
  alias EctoDot.Diagram

  @doc """
  Creates the .dot representation including attributes and associations between the received schema module/s.

  Note: only associations between received modules will be shown.
  """
  def diagram(mods, opts \\ [])

  def diagram(mod, opts) when is_atom(mod) do
    diagram([mod], opts)
  end

  def diagram(mods, opts) when is_list(mods) do
    name = Keyword.get(opts, :name, "Diagram")

    schemas =
      mods
      |> Enum.map(&Schema.from_ecto/1)

    associations =
      mods
      |> Enum.flat_map(&Association.from_ecto/1)
      |> Enum.filter(fn assoc ->
        Enum.member?(mods, assoc.to)
      end)

    %Diagram{name: name, schemas: schemas, associations: associations}
  end

  @doc """
  Creates the .dot representation including attributes and associations accesible from the received schema module/s.
  """
  def expanded_diagram(mods, opts \\ [])

  def expanded_diagram(mod, opts) when is_atom(mod) do
    expanded_diagram([mod], opts)
  end

  def expanded_diagram(mods, opts) when is_list(mods) do
    reachable_modules =
      expand_modules(MapSet.new(), MapSet.new(mods))
      |> MapSet.to_list()

    diagram(reachable_modules, opts)
  end

  defp expand_modules(reachable, to_expand) do
    if Enum.empty?(to_expand) do
      reachable
    else
      will_expand = Enum.at(to_expand, 0)
      new_reachable = MapSet.put(reachable, will_expand)

      rest_to_expand = MapSet.delete(to_expand, will_expand)

      new_to_expand =
        Association.from_ecto(will_expand)
        |> Enum.map(fn assoc -> assoc.to end)
        |> Enum.into(MapSet.new())
        |> MapSet.union(rest_to_expand)
        |> MapSet.difference(new_reachable)

      expand_modules(new_reachable, new_to_expand)
    end
  end

  @doc """
  Exports a diagram. Params:
      * A diagram returned from `diagram/2` or `expanded_diagram/2`
      * The path where the file/s will be generated, including the filename (no extension)
      * A list with the formats you want to be exported: [:dot, :png, :svg, :pdf]
  """
  def export(%Diagram{} = diag, path, formats \\ [:dot]) do
    dot = Diagram.to_dot(diag)
    output_file = fn format -> Path.rootname(path) <> ".#{format}" end
    dot_file = output_file.(:dot)

    # need to generate anyway
    File.write(dot_file, dot)

    try do
      formats
      |> Enum.each(fn
        format when format in [:png, :svg, :pdf] ->
          file = output_file.(format)
          IO.puts("Generating #{file}")
          System.cmd("dot", ["-T#{format}", dot_file, "-o#{file}"])

        :dot ->
          IO.puts("Generating #{dot_file}")
      end)
    rescue
      _ ->
        IO.puts(
          "It seems dot is not installed or in PATH. Please install it if you want to generate png, svg or pdf files with it."
        )
    after
      if :dot not in formats do
        File.rm(dot_file)
      end
    end

    :ok
  end
end
