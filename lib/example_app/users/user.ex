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