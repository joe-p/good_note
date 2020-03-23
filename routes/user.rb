class GoodNote < Roda
  plugin :hash_routes

  hash_branch "user" do |r|
    r.on Integer do |user_id|
      User[user_id]
    end
  end 
end
