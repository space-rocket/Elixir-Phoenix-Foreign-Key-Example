defmodule ExampleApp.ObjectTypes.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExampleApp.ObjectTypes.ProjectManager

  @primary_key false
  schema "projects" do
    field :name, :string
    belongs_to :project_manager, ProjectManager,
      foreign_key: :owner_id,
      type: :string,
      primary_key: true,
      references: :wf_user_id

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:owner_id, name: "project_pkey")

  end
end