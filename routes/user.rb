class GoodNote < Roda
  plugin :hash_routes
  plugin :render

  hash_branch 'user' do |r|
    user_id = session['user_id']
    current_user = User[user_id]

    r.on 'clients' do
      if user_id
        if current_user[:is_therapist]
          User.all.select { |u| u[:therapist] == user_id }
        else
          'You must be a therapist to view this page'
        end
      else
        r.redirect '/spotify/auth'
      end
    end

    r.on 'therapist' do
      r.post do
        id = r.params['id']
        therapist = User[spotify_id: id]

        if therapist[:is_therapist]
          current_user[:therapist] = id
          r.redirect 'therapist'
        else
          r.redirect "invalid?id=#{id}"
        end
      end

      r.get 'invalid' do
        r.params['id'] + ' is not registered as a therapist'
      end

      r.get do
        if current_user[:therapist]
          User[current_user[:therapist]]
        else
          render 'registration'
        end
      end
    end
  end
end
