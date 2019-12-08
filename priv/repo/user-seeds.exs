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