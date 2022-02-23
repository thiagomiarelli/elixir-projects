defmodule DiscussWeb.TopicController do
 use DiscussWeb, :controller
 alias Discuss.Discussions.Topic

def index(conn, _params) do
  IO.inspect(conn.assigns)
  topics = Discuss.Repo.all(Topic)
  render conn, "index.html", topics: topics
end

 def new(conn,_params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
 end

 @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
 def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
    case Discuss.Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created sucessfully")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
 end

 def edit(conn, %{"id" => topic_id}) do
    topic = Discuss.Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
 end

 def update(conn, %{"id"=> id, "topic" => topic}) do
  old_topic = Discuss.Repo.get(Topic, id)
  changeset = Topic.changeset(old_topic, topic)

    case Discuss.Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated sucessfully")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
      end
 end

 def delete(conn, %{"id" => id}) do
   Discuss.Repo.get(Topic, id)
    |> Discuss.Repo.delete!

   conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
 end
end
