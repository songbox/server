defmodule Songbox.SongController do
  use Songbox.Web, :controller

  alias Songbox.Song
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    songs = Repo.all(Song)
    render(conn, "index.json-api", data: songs)
  end

  def create(conn, %{"data" => data = %{"type" => "song", "attributes" => _song_params}}) do
    changeset = Song.changeset(%Song{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, song} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", song_path(conn, :show, song))
        |> render("show.json-api", data: song)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    song = Repo.get!(Song, id)
    render(conn, "show.json-api", data: song)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "song", "attributes" => _song_params}}) do
    song = Repo.get!(Song, id)
    changeset = Song.changeset(song, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, song} ->
        render(conn, "show.json-api", data: song)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    song = Repo.get!(Song, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(song)

    send_resp(conn, :no_content, "")
  end

end
