defmodule ExampleAppTest do
  use ExampleApp.DataCase
  alias ExampleApp.Users.User
  alias ExampleApp.ObjectTypes.ProjectManager

  setup do
    data = [
      %{
        "ID" => "5ba94a2a00854529705f809ebec755b9",
        "emailAddr" => "user1@test.com"
      },
      %{
        "ID" => "5b93028601bd041b925dc2067422be82",
        "emailAddr" => "user2@test.com"
      },
      %{
        "ID" => "5b89e3d300abc77aa4885e819fe3713d",
        "emailAddr" => "user3@test.com"
      }
    ]

    Enum.each(data, fn %{"ID" => wf_user_id, "emailAddr" => email} ->
      Repo.insert!(%User{
        wf_user_id: wf_user_id,
        email: email
      })
    end)

    data = [
      %{
        "ownerID" => "5ba94a2a00854529705f809ebec755b9"
      },
      %{
        "ownerID" => "5b93028601bd041b925dc2067422be82"
      },
      %{
        "ownerID" => "5b89e3d300abc77aa4885e819fe3713d"
      }
    ]

    Enum.each(data, fn %{"ownerID" => wf_user_id} ->
      Repo.insert!(%ProjectManager{
        wf_user_id: wf_user_id
      })
    end)
  end

  test "it works" do
    assert [
             %User{email: "user1@test.com", wf_user_id: "5ba94a2a00854529705f809ebec755b9"},
             %User{email: "user2@test.com", wf_user_id: "5b93028601bd041b925dc2067422be82"},
             %User{email: "user3@test.com", wf_user_id: "5b89e3d300abc77aa4885e819fe3713d"}
           ] = _users = Repo.all(User)

    assert [
             %ProjectManager{wf_user_id: "5ba94a2a00854529705f809ebec755b9"},
             %ProjectManager{wf_user_id: "5b93028601bd041b925dc2067422be82"},
             %ProjectManager{wf_user_id: "5b89e3d300abc77aa4885e819fe3713d"}
           ] = project_managers = Repo.all(ProjectManager)

    assert [
             %ProjectManager{
               user: %User{
                 email: "user1@test.com",
                 wf_user_id: "5ba94a2a00854529705f809ebec755b9"
               },
               wf_user_id: "5ba94a2a00854529705f809ebec755b9"
             },
             %ProjectManager{
               user: %User{
                 email: "user2@test.com",
                 wf_user_id: "5b93028601bd041b925dc2067422be82"
               },
               wf_user_id: "5b93028601bd041b925dc2067422be82"
             },
             %ProjectManager{
               user: %User{
                 email: "user3@test.com",
                 wf_user_id: "5b89e3d300abc77aa4885e819fe3713d"
               },
               wf_user_id: "5b89e3d300abc77aa4885e819fe3713d"
             }
           ] = Repo.preload(project_managers, :user)
  end
end
