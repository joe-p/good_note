class User < Sequel::Model(DB[:users])
  plugin :json_serializer

  class << self
    def authenticate_via_spotify(code)
      post_body = {
        "grant_type" => "authorization_code",
        "code" => code,
        "redirect_uri" => "#{MusicTherapy::HOSTNAME}/spotify/auth/callback",
        "client_id" => MusicTherapy::CLIENT_ID,
        "client_secret" => MusicTherapy::CLIENT_SECRET
      }

      conn = Faraday.new
      token_res = conn.post('https://accounts.spotify.com/api/token', post_body)

      token = JSON.parse(token_res.body)["access_token"]

      me_res = conn.get('https://api.spotify.com/v1/me', nil, {"Authorization" => "Bearer #{token}"})

      me_hash = JSON.parse(me_res.body)

      User.find_or_create spotify_id: me_hash["id"] 
    end

  end
end
