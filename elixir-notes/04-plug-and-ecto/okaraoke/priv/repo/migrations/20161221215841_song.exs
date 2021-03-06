defmodule Okaraoke.Repo.Migrations.Song do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :external_id, :string, unique: true
      add :description, :string

      timestamps
    end
  end
end
