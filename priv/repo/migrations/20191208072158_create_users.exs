defmodule ExampleApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :wf_user_id, :string, primary_key: true
      add :email, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
