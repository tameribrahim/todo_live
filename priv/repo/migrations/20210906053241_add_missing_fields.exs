defmodule TodoLive.Repo.Migrations.AddMissingFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :channels, {:array, :string}
    end

    alter table(:todos) do
      add :channels, {:array, :string}
    end
  end
end
