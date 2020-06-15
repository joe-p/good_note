class GoodNote < Roda
  plugin :hash_routes
  plugin :render
  plugin :static, ["/images", "/css", "/js"]

  hash_branch 'session' do |r|
    r.on 'home' do
      render 'home'
    end

    r.on 'activity' do
      render 'activity'
    end

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
