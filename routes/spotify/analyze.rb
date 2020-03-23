require 'rspotify'

class MusicTherapy < Roda

  plugin :hash_routes

  RSpotify::authenticate ENV["CLIENT_ID"], ENV["CLIENT_SECRET"]

  hash_branch :spotify, "rspotify" do |r|
    r.get do
      rspotify_user(session_access_token(r)).instance_variable_hash
    end
  end
  
  hash_branch :spotify, "analyze" do |r|
    r.is "song", String do |id|
      RSpotify::AudioFeatures.find(id).instance_variables_hash
    end

    r.is "playlist", String do |id|
      RSpotify::Playlist.find_by_id id
    end

  end
end
