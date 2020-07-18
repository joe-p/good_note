Sequel.migration do
  change do
    create_table(:activities) do
      primary_key :id
      DateTime :time
      String :patient_id
      Text :request
      Text :response
    end
  end
end
