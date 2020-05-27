class GoodNote < Roda
  plugin :hash_routes

  hash_branch 'user' do |r|
    r.on 'clients' do
      user_id = session['user_id']
      if user_id
        if User[user_id][:is_therapist]
          User.all.select {|u|  u[:therapist] == user_id}
        else
          "You must be a therapist to view this page"
        end
      else
        r.redirect "/spotify/auth"
      end
    end
  end

  
end
