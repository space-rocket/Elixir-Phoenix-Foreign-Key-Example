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