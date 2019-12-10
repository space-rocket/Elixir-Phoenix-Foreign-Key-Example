defmodule ExampleApp.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :name, :string

      timestamps()
    end

  end
end