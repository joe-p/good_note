Sequel.migration do
    change do
        # is_therpist
        # true if the user is a therapist with clients
        # false otherwise
        add_column :users, :is_therapist, :boolean
        
        # therapist
        # The ID (primary key) for this client's therapist
        add_column :users, :therapist, Integer
    end
end