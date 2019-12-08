defmodule ExampleApp.ObjectTypes.ProjectManager do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExampleApp.Users.User

  @primary_key false
  schema "project_managers" do
    belongs_to :user, User,
      foreign_key: :wf_user_id,
      type: :string,
      primary_key: true,
      references: :wf_user_id

    timestamps()
  end

  @doc false
  def changeset(project_manager, attrs) do
    project_manager
    |> cast(attrs, [])
    |> validate_required([:wf_user_id])
    |> unique_constraint(:wf_user_id, name: "project_managers_pkey")
  end
end
