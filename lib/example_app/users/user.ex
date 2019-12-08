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
    |> cast(attrs, [:wf_user_id, :email])
    |> validate_required([:wf_user_id, :email])
    |> unique_constraint(:wf_user_id, name: "users_pkey")
    |> unique_constraint(:email)
  end
end
