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
  # %{
  #   "ID" => "5be47a96009c964a240ec2b57c0d256f",
  #   "name" => "Project 4",
  #   "project_manager_id" => nil,
  #   "ownerID" => nil
  # },
  # %{
  #   "ID" => "5c069ec7001875b512a47eec0ff81e99",
  #   "name" => "Project 5",
  #   "project_manager_id" => 2,
  #   "ownerID" => "5b93028601bd041b925dc2067422be82"
  # }
]

Enum.each data, fn(project) ->

  name = Map.get(project, "name")
  _project_manager_id = Map.get(project, "project_manager_id")
  owner_id = Map.get(project, "ownerID")

  # Insert data into database
  Repo.insert! %Project{
    name: name,
    owner_id: owner_id,
    
  }
end