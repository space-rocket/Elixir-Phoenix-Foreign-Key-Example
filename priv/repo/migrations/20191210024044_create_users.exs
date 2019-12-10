defmodule ExampleApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :email, :string
      add :wf_user_id, :string, primary_key: true

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end