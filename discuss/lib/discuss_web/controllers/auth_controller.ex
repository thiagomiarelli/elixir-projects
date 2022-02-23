defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth
  alias Discuss.Auth.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_info = auth.extra.raw_info.user
    name = user_info["name"]
    {_ok, email} = user_info["emails"]
    |> Enum.at(0)
    |> Map.fetch("email")


    user_params = %{token: auth.credentials.token, email: email, name: name, provider: "github"}
    changeset = Discuss.Auth.User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome, back #{user.name}")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Discuss.Repo.get_by(User, email: changeset.changes.email) do
      nil -> Discuss.Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
end
