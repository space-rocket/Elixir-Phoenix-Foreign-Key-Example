defmodule ExampleApp.Repo.Migrations.AddProjectManagerIdToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
        add :owner_id, references(:project_managers,
          column: :wf_user_id,
          type: :string,  
          on_delete: :delete_all
        ), 
        primary_key: true
    end
  end
end