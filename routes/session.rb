class GoodNote < Roda
  plugin :hash_routes
  plugin :render

  hash_branch 'session' do |r|
    r.on 'notes' do

      therapist_id = session['user_id']

      # POST
      r.post do
        puts r.params

        client_id = r.params['client']
        date = r.params['date']

        if r.params['notes']
          Note.update_or_create(
            {
              therapist_id: therapist_id,
              patient_id: client_id,
              creation_date: date
            },
            content: r.params['notes']
          )
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
  end
end
