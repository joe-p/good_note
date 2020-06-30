Sequel.migration do
  change do
    create_table(:notes) do
      primary_key :id
      String :therapist_id
      String :patient_id
      String :content
      Date :creation_date
    end
  end
end