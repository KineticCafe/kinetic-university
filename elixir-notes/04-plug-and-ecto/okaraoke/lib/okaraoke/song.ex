defmodule Okaraoke.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :external_id, :string
    field :description, :string

    many_to_many :keywords, Okaraoke.Keyword, join_through: "songs_keywords"

    timestamps
  end

  def changeset(song, params \\ :empty) do
    song
    |> cast(params, [:external_id, :description])
    |> validate_length(:external_id, min: 11)
    |> unique_constraint(:external_id)
  end
end
