# EctoDot

Create .dot diagrams from your ecto schemas. Export them to `png`, `svg` or `pdf`.

The project it's on a very early stage, so you can expect edge cases and bugs.

## Installation

The package can be installed by adding `ecto_dot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_dot, "~> 0.1.0"}
  ]
end
```

#### NOTE: if you want to export to png, svg or pdf formats you need to have `dot` installed.

## Usage

All these examples assume you have 3 Ecto schemas `User`, `Post` and `Comment`. You can find the code in [ecto_example_code].

* Generate `dot` and `png` files for the schema `User`:

```elixir
EctoDot.diagram(User)
|> EctoDot.export("examples/readme/user", [:dot, :png])
```

![user_diagram]

* Generate `svg` files for the schemas `User` and `Post`:

```elixir
EctoDot.diagram([User, Post])
|> EctoDot.export("examples/readme/user_post", [:svg])
```

![user_post_diagram]

`diagram/2` only uses the schemas you passed in to form the diagram, if you find that tiring,
you can use `expanded_diagram/2` which will expand the relations from the modules you pass into it.

* Generate `dot` and `png` files for all the schemas accessible from `User` (all 3 schemas) :

```elixir
EctoDot.expanded_diagram(User)
|> EctoDot.export("examples/readme/blog", [:dot, :png])
```

![blog_diagram]

## Help

Feel free to open issues with bugs, suggest ideas and submit PRs if you are interested on this project.

[ecto_example_code]: test/support
[user_diagram]: examples/readme/user.png "User Diagram"
[user_post_diagram]: examples/readme/user_post.svg "User-Post Diagram"
[blog_diagram]: examples/readme/blog.png "Blog Diagram"
