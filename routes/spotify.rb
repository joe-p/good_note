require_relative 'spotify/auth'
require_relative 'spotify/analyze'

class MusicTherapy < Roda
  plugin :hash_routes

  def session_access_token(r)
    r.session["auth_info"]["access_token"]
  end

  def rspotify_user(token)
    me_res = Faraday.new.get('https://api.spotify.com/v1/me', nil, {"Authorization" => "Bearer #{token}"})
    me_hash = JSON.parse(me_res.body) 
    
    init_hash = me_hash.dup
    init_hash["credentials"] = { "token" => token }       

    RSpotify::User.new init_hash 
  end

  hash_branch "spotify" do |r|
    r.hash_routes(:spotify)
  end 
end
