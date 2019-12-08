defmodule ExampleApp.Repo.Migrations.CreateProjectManagers do
  use Ecto.Migration

  def change do
    create table(:project_managers) do
      add :wf_user_id, references(:users, column: :wf_user_id, type: :string, on_delete: :delete_all), null: false, primary_key: true

      timestamps()
    end

    create unique_index(:project_managers, [:wf_user_id])
  end
end
