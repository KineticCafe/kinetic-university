defmodule Okaraoke.Repo.Migrations.AddSongsKeywordsTable do
  use Ecto.Migration

  def change do
    create table(:songs_keywords) do
      add :song_id, references(:songs)
      add :keyword_id, references(:keywords)
    end
  end
end
