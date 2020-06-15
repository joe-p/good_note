class GoodNote < Roda
  plugin :hash_routes
  plugin :render

  hash_branch 'session' do |r|
    r.on 'notes' do
      r.post do
        r.redirect "notes?client=#{r.params['client']}&date=#{r.params['date']}"
      end

      @clients = User.all
      @current_client = r.params['client'] || ''
      @selected_date = r.params['date'] || '2020-01-01'

      render 'notes'
    end
  end
end
