# ExampleApp 

First, make sure you have Elixir and Phoenix installed:

- [https://hexdocs.pm/phoenix/installation.html](https://hexdocs.pm/phoenix/installation.html)

Also make sure you have PostgreSQL installed:

- [https://wiki.postgresql.org/wiki/Detailed_installation_guides](https://wiki.postgresql.org/wiki/Detailed_installation_guides)


```elixir
mix phx.new example_app
```


```elixir
cd example_app
```


```elixir
mix ecto.create
```


```elixir
mix phx.server
```

### Add Users 

```bash
mix phx.gen.schema Users.User users email:string:unique wf_user_id:string:unique
```

**lib/example_app/users/user.ex**
```elixir
defmodule ExampleApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users" do
    field :email, :string
    field :wf_user_id, :string, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :wf_user_id])
    |> validate_required([:email, :wf_user_id])
    |> unique_constraint(:email)
    |> unique_constraint(:wf_user_id, name: "users_pkey")
  end
end

```

**priv/repo/migrations/20191208072158_create_users.exs**
```elixir
defmodule ExampleApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :email, :string
      add :wf_user_id, :string, primary_key: true

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:wf_user_id])
  end
end


```


## Add Projects

```bash
mix phx.gen.schema ObjectTypes.Project projects name:string 
```

```elixir
defmodule ExampleApp.ObjectTypes.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "projects" do
    field :name, :string
  
    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
```


**priv/repo/migrations/20191209044817_create_projects.exs**
```elixir
defmodule ExampleApp.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :name, :string

      timestamps()
    end

  end
end
```

```bash
mix ecto.migrate
```

## Add Project Managers 

```
mix phx.gen.schema ObjectTypes.ProjectManager project_managers wf_user_id:references:users:unique
```

**lib/example_app/object_types/project_manager.ex**
```elixir
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
    |> validate_required([])
    |> unique_constraint(:wf_user_id, name: "project_managers_pkey")
  end
end

```

**priv/repo/migrations/20191210014200_create_project_managers.exs**
```elixir
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

```


```bash
mix ecto.migrate
```





## Add Project Manager ID to Projects Migration

```bash
mix ecto.gen.migration add_project_manager_id_to_projects
```

**priv/repo/migrations/20191209044933_add_project_manager_id_to_projects.exs**
```elixir
defmodule ExampleApp.Repo.Migrations.AddProjectManagerIdToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
        add :project_manager_id, 
        references(:project_managers,
          column: :wf_user_id,
          type: :string,  
          on_delete: :delete_all
        ), 
        primary_key: true
    end
  end
end

```

```bash
mix ecto.migrate
```

## Add ProjectManager Association to Project Schema and Vis Versa



**belongs_to**`:foreign_key` and the **has_many** `:foreign_key` should be set with the same value.

`:references` - Sets the key on the other schema to be used for the association

**lib/example_app/object_types/project.ex**
```elixir
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
      references: :owner_id

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
```

`has_many` doesn't require you to set it primary key like `belongs_to` does. Thats because you have to add key its going to being using, ex: `field :owner_id, :string, primary_key: true`

**lib/example_app/object_types/project_manager.ex**
```elixir
defmodule ExampleApp.ObjectTypes.ProjectManager do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExampleApp.Users.User
  alias ExampleApp.ObjectTypes.Project

  @primary_key false
  schema "project_managers" do
    field :owner_id, :string, primary_key: true
    has_many :projects, Project, 
      foreign_key: :owner_id,
      references: :owner_id
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
```

```bash
mix ecto migrate
```

😩 Error:

```sql
iex(2)> project_manager = Repo.all(from p in ProjectManager)
[debug] QUERY ERROR source="project_managers" db=0.0ms queue=6.2ms
SELECT p0."owner_id", p0."wf_user_id", p0."inserted_at", p0."updated_at" FROM "project_managers" AS p0 []
** (Postgrex.Error) ERROR 42703 (undefined_column) column p0.owner_id does not exist

    query: SELECT p0."owner_id", p0."wf_user_id", p0."inserted_at", p0."updated_at" FROM "project_managers" AS p0
    (ecto_sql) lib/ecto/adapters/sql.ex:629: Ecto.Adapters.SQL.raise_sql_call_error/1
    (ecto_sql) lib/ecto/adapters/sql.ex:562: Ecto.Adapters.SQL.execute/5
    (ecto) lib/ecto/repo/queryable.ex:177: Ecto.Repo.Queryable.execute/4
    (ecto) lib/ecto/repo/queryable.ex:17: Ecto.Repo.Queryable.all/3
```


```sql
example_app_dev=# \d project_managers
                        Table "public.project_managers"
   Column    |              Type              | Collation | Nullable | Default 
-------------+--------------------------------+-----------+----------+---------
 wf_user_id  | character varying(255)         |           | not null | 
 inserted_at | timestamp(0) without time zone |           | not null | 
 updated_at  | timestamp(0) without time zone |           | not null | 
Indexes:
    "project_managers_pkey" PRIMARY KEY, btree (wf_user_id)
Foreign-key constraints:
    "project_managers_wf_user_id_fkey" FOREIGN KEY (wf_user_id) REFERENCES users(wf_user_id) ON DELETE CASCADE
Referenced by:
    TABLE "projects" CONSTRAINT "projects_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES project_managers(wf_user_id) ON DELETE CASCADE
```

Ref:
[Docs: Ecto Schema has_many](https://hexdocs.pm/ecto/Ecto.Schema.html#has_many/3)

## Seed User table with Mock Data from JSON response

**priv/repo/user-seeds.exs**
```elixir
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/user-seeds.exs

alias ExampleApp.Repo
alias ExampleApp.Users.User

# ID is from legacy system
data = [
  %{
    "ID" => "5ba94a2a00854529705f809ebec755b9",
    "emailAddr" => "user1@test.com",
  },
  %{
    "ID" => "5b93028601bd041b925dc2067422be82",
    "emailAddr" => "user2@test.com",
  },
  %{
    "ID" => "5b89e3d300abc77aa4885e819fe3713d",
    "emailAddr" => "user3@test.com",
  }
]

Enum.each data, fn(user) ->

  # Map Data here
  wf_user_id = Map.get(user, "ID")
  email_addr = Map.get(user, "emailAddr")

  # Insert data into database
  Repo.insert! %User{
    wf_user_id: wf_user_id,
    email: email_addr
  }
end
```

```bash
mix run priv/repo/user-seeds.exs
```


## Seed Project Manager table with Mock Data from JSON response

**priv/repo/project-manager-seeds.exs**
```elixir
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/project-manager-seeds.exs

alias ExampleApp.Repo
alias ExampleApp.ObjectTypes.{ProjectManager}

data = [
  %{
    "ID" => "5ba94b28008708718d6e1b4d36a79770",
    "name" => "Project 1",
    "ownerID" => "5ba94a2a00854529705f809ebec755b9"
  },
  %{
    "ID" => "5bae225c02b878793ca699dc8a4b9b9a",
    "name" => "Project 2",
    "ownerID" => "5b93028601bd041b925dc2067422be82"
  },
  %{
    "ID" => "5bc8ae5a00251a1cb4ee27c4860e29b1",
    "name" => "Project 3",
    "ownerID" => "5b89e3d300abc77aa4885e819fe3713d"
  }
]

Enum.each data, fn(project_manager) ->

  wf_user_id = Map.get(project_manager, "ownerID")

  # Insert data into database
  Repo.insert! %ProjectManager{
    wf_user_id: wf_user_id
  }
end
```

```bash
mix run priv/repo/project-manager-seeds.exs
```


## Seed Project table with Mock Data from JSON response

**priv/repo/project-seeds.exs**
```elixir
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/project-seeds.exs

alias ExampleApp.Repo
alias ExampleApp.ObjectTypes.{Project}

data = [
  %{
    "ID" => "5ba94b28008708718d6e1b4d36a79770",
    "name" => "Project 1",
    "project_manager_id" => 1,
    "ownerID" => "5ba94a2a00854529705f809ebec755b9"
  },
  %{
    "ID" => "5bae225c02b878793ca699dc8a4b9b9a",
    "name" => "Project 2",
    "project_manager_id" => 2,
    "ownerID" => "5b93028601bd041b925dc2067422be82"
  },
  %{
    "ID" => "5bc8ae5a00251a1cb4ee27c4860e29b1",
    "name" => "Project 3",
    "project_manager_id" => 3,
    "ownerID" => "5b89e3d300abc77aa4885e819fe3713d"
  },
  %{
    "ID" => "5be47a96009c964a240ec2b57c0d256f",
    "name" => "Project 4",
    "project_manager_id" => nil,
    "ownerID" => nil
  },
  %{
    "ID" => "5c069ec7001875b512a47eec0ff81e99",
    "name" => "Project 5",
    "project_manager_id" => 2,
    "ownerID" => "5b93028601bd041b925dc2067422be82"
  }
]

Enum.each data, fn(project) ->

  name = Map.get(project, "name")
  project_manager_id = Map.get(project, "project_manager_id")
  wf_user_id = Map.get(project, "ownerID")

  # Insert data into database
  Repo.insert! %Project{
    name: name,
    project_manager_id: project_manager_id,
    
  }
end
```

```bash
mix run priv/repo/project-seeds.exs
```

Do a reset and reseed:
```shell
mix ecto.reset && mix run priv/repo/user-seeds.exs \
&& mix run priv/repo/project-manager-seeds.exs \
&& mix run priv/repo/project-seeds.exs
```

## Customize iex

**.iex.exs**
```
import_if_available Ecto.Query

alias ExampleApp.{
    Repo,
    Users.User,
    ObjectTypes,
    ObjectTypes.Project,
    ObjectTypes.ProjectManager
}
```

Test it out:
```bash
iex -S mix
```

```bash
users = Repo.all(from u in User)
```

```bash
project_manager = Repo.all(from p in ProjectManager)
```

```bash
project_manager = Repo.all(from p in ProjectManager, preload: :user)
```

```bash
project_manager = Repo.all(from p in ProjectManager, preload: :projects)
```

```bash
projects = Repo.all(from p in Project)
```

```bash
projects = Repo.all(from p in Project, preload: :project_manager)
```

```bash
q = from Project, where: [project_manager_id: 2]
Repo.all(q)
```


https://hexdocs.pm/ecto/Ecto.Schema.html#belongs_to/3

https://hexdocs.pm/ecto_sql/Ecto.Migration.html#table/2 1
https://hexdocs.pm/ecto/Ecto.Schema.html#belongs_to/3-options 1
