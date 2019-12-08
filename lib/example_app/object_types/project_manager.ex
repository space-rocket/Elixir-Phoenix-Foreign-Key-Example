defmodule ExampleApp.ObjectTypes.ProjectManager do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExampleApp.Users.User
  # use ExampleApp.Schema


  schema "project_managers" do
    belongs_to :user, User, foreign_key: :wf_user_id, type: :string, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(project_manager, attrs) do
    project_manager
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:wf_user_id)
  end
end
