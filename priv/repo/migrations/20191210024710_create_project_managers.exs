defmodule ExampleApp.Repo.Migrations.CreateProjectManagers do
  use Ecto.Migration

  def change do
    create table(:project_managers, primary_key: false) do
      add :wf_user_id,
          references(:users, 
            column: :wf_user_id, 
            type: :string, 
            on_delete: :delete_all
          ),
          primary_key: true

      timestamps()
    end

  end
end