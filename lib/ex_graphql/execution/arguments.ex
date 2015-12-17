defmodule ExGraphQL.Execution.Arguments do

  alias ExGraphQL.Execution.Literal

  def build(ast_arguments, schema_arguments, variables) do
    schema_arguments
    |> Enum.reduce(%{}, fn ({name, definition}, acc) ->
      schema_arg_name = name |> to_string
      ast_arg = ast_arguments |> Enum.find(&(&1.name == schema_arg_name))
      if ast_arg do
        ast_value = if ast_arg.value do
          Literal.coerce(definition.type, ast_arg.value, variables)
        else
          nil
        end
        variable_value = variables[ast_arg.name]
        default_value = definition.default_value
        acc
        |> Map.put(name, ast_value || variable_value || default_value)
      else
        acc
      end
    end)
  end

end