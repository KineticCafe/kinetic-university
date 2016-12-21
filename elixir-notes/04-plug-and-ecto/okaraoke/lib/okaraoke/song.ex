defmodule Okaraoke.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :external_id, :interger
    field :description, :string

    timestamps
  end


  def changeset(song, params \\ :empty) do
    song
    |> cast(params, [:external_id, :description])
    |> unique_constraint(:external_id)
  end
end
