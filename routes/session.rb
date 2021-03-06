class GoodNote < Roda
  plugin :hash_routes
  plugin :render
  plugin :static, ["/images", "/css", "/js"]

  hash_branch 'session' do |r|
    r.on 'home' do
      render 'home'
    end

    r.on 'activity' do
      # TODO: Filter for clients of logged in therapist
      client_ids = User.all.map(&:spotify_id).compact

      @activities = Activity.where([[:patient_id, client_ids]])

      render 'activity'
    end

    r.on 'notes' do

      therapist_id = session['user_id']

      # POST
      r.post do
        puts r.params

        client_id = r.params['client']
        date = r.params['date']

        if r.params['notes']
          note = Note.update_or_create(
            {
              therapist_id: therapist_id,
              patient_id: client_id,
              creation_date: date
            },
            content: r.params['notes']
          )

          note.delete if note[:content].empty?
        end
        
        r.redirect "notes?client=#{r.params['client']}&date=#{r.params['date']}"
      end

      # GET
      r.get do
        @clients = User.all
        @current_client = r.params['client'] || ''
        @selected_date = r.params['date'] || '2020-01-01'

        note = Note[{ patient_id: @current_client, therapist_id: therapist_id, creation_date: @selected_date }]

        @note_content = note ? note[:content] : ''

        puts @note_content

        render 'notes'
      end
    end

    r.on 'login' do
      render 'login'
    end

  end
end
