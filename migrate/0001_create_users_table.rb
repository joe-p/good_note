Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :spotify_id
    end
  end
end
