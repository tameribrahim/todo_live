defmodule TodoLive.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :created_by, references(:users, on_delete: :nilify_all)

      timestamps()
    end
  end
end
