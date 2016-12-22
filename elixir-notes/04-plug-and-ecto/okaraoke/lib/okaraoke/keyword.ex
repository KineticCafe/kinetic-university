defmodule Okaraoke.Keyword do
  use Ecto.Schema

  schema "keywords" do
    field :keyword, :string

    many_to_many :songs, Okaraoke.Song, join_through: "songs_keywords"

    timestamps
  end
end
