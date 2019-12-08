defmodule ExampleApp.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:wf_user_id, :string, autogenerate: false}
      @foreign_key_type :string
    end
  end
end