class User < Sequel::Model(DB[:users])
  plugin :json_serializer

  class << self
    def authenticate_via_spotify(code)
      b64 = Base64.strict_encode64("#{GoodNote::CLIENT_ID}:#{GoodNote::CLIENT_SECRET}")
      
      api_conn = Faraday.new("https://accounts.spotify.com/api/")
 
      token_res = api_conn.post("token") do |req|
        req.body = {
          "grant_type" => "authorization_code",
          "code" => code,
          "redirect_uri" => "#{GoodNote::HOSTNAME}/spotify/auth/callback"
        }

        req.headers = {"Authorization" => "Basic #{b64}"}
      end

      auth_info = JSON.parse(token_res.body)
      
      token = auth_info["access_token"]

      me_res = Faraday.new.get('https://api.spotify.com/v1/me', nil, {"Authorization" => "Bearer #{token}"})
      me_hash = JSON.parse(me_res.body)

      current_user = User.find_or_create( spotify_id: me_hash["id"] )

      [ current_user , auth_info ]
    end

  end

end
