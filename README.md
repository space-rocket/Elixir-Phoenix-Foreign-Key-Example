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

### Pt 1: Add Users 

```bash
mix phx.gen.schema Users.User users wf_user_id:string:unique email:string:unique 
```

# Pt 2: Add Project Managers 

```
mix phx.gen.schema ObjectTypes.ProjectManager project_managers wf_user_id:references:users:unique
```

## Add Belongs to User to Project Manager


**lib/example_app/object_types/project_manager.ex**
```elixir
defmodule ExampleApp.ObjectTypes.ProjectManager do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExampleApp.Users.User
  # use ExampleApp.Schema


  schema "project_managers" do
    belongs_to :user, User, foreign_key: :wf_user_id, type: :string, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(project_manager, attrs) do
    project_manager
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:wf_user_id)
  end
end
```

## Set schema primary keys and foreign key type

Also tried with this, but still no dice:(

**lib/example_app/schema.ex**
```elixir
defmodule ExampleApp.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:wf_user_id, :string, autogenerate: false}
      @foreign_key_type :string
    end
  end
end
```

**priv/repo/migrations/20191208072158_create_users.exs**
```elixir
defmodule ExampleApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :wf_user_id, :string, primary_key: true
      add :email, :string

      timestamps()
    end

    create unique_index(:users, [:wf_user_id])
    create unique_index(:users, [:email])
  end
end
```


**priv/repo/migrations/20191208072217_create_project_managers.exs**
```elixir
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
```


### Customize iex

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

### Seed User table with Mock Data from JSON response

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


Do a reset and reseed:

```shell
mix ecto.reset && mix run priv/repo/user-seeds.exs \
&& mix run priv/repo/project-manager-seeds.exs
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
project_manager = Repo.all(from p in ProjectManager, preload: [:user])
```

```sql
iex(3)> project_manager = Repo.all(from p in ProjectManager, preload: [:user])
[debug] QUERY OK source="project_managers" db=0.3ms
SELECT p0."id", p0."wf_user_id", p0."inserted_at", p0."updated_at" FROM "project_managers" AS p0 []
** (Ecto.Query.CastError) deps/ecto/lib/ecto/association.ex:901: value `["5b89e3d300abc77aa4885e819fe3713d", "5b93028601bd041b925dc2067422be82", "5ba94a2a00854529705f809ebec755b9"]` in `where` cannot be cast to type {:in, :id} in query:

from u0 in ExampleApp.Users.User,
  where: u0.id in ^["5b89e3d300abc77aa4885e819fe3713d", "5b93028601bd041b925dc2067422be82", "5ba94a2a00854529705f809ebec755b9"],
  select: {u0.id, u0}

    (elixir) lib/enum.ex:1948: Enum."-reduce/3-lists^foldl/2-0-"/3
    (elixir) lib/enum.ex:1440: Enum."-map_reduce/3-lists^mapfoldl/2-0-"/3
    (elixir) lib/enum.ex:1948: Enum."-reduce/3-lists^foldl/2-0-"/3
    (ecto) lib/ecto/repo/queryable.ex:161: Ecto.Repo.Queryable.execute/4
    (ecto) lib/ecto/repo/queryable.ex:17: Ecto.Repo.Queryable.all/3
    (elixir) lib/enum.ex:1336: Enum."-map/2-lists^map/1-0-"/2
```


```bash
q = from ProjectManager, where: [wf_user_id: "5b93028601bd041b925dc2067422be82"]
Repo.all(q)
```

```sql
iex(1)> q = from ProjectManager, where: [wf_user_id: "5b93028601bd041b925dc2067422be82"]
#Ecto.Query<from p0 in ExampleApp.ObjectTypes.ProjectManager,
 where: p0.wf_user_id == "5b93028601bd041b925dc2067422be82">
iex(2)> Repo.all(q)
[debug] QUERY OK source="project_managers" db=6.1ms decode=1.0ms queue=2.9ms
SELECT p0."id", p0."wf_user_id", p0."inserted_at", p0."updated_at" FROM "project_managers" AS p0 WHERE (p0."wf_user_id" = '5b93028601bd041b925dc2067422be82') []
[
  %ExampleApp.ObjectTypes.ProjectManager{
    __meta__: #Ecto.Schema.Metadata<:loaded, "project_managers">,
    id: 2,
    inserted_at: ~N[2019-12-08 08:00:11],
    updated_at: ~N[2019-12-08 08:00:11],
    user: #Ecto.Association.NotLoaded<association :user is not loaded>,
    wf_user_id: "5b93028601bd041b925dc2067422be82"
  }
]
```



