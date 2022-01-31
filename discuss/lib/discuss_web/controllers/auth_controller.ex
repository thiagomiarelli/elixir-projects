defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  def callback(conn, params) do
    IO.puts("MAP")
    IO.inspect(conn.assigns)
    IO.puts("PARAMS")
    IO.inspect(params)
  end
end
