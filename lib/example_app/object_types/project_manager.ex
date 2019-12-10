defmodule ExampleApp.ObjectTypes.ProjectManager do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExampleApp.Users.User
  alias ExampleApp.ObjectTypes.Project

  @primary_key false
  schema "project_managers" do
    has_many :projects, Project, 
      foreign_key: :owner_id,
      references: :wf_user_id
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
    |> validate_required([])
    |> unique_constraint(:wf_user_id, name: "project_managers_pkey")
  end
end