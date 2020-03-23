require 'rspotify'


class GoodNote < Roda

  plugin :hash_routes

  RSpotify::authenticate ENV["CLIENT_ID"], ENV["CLIENT_SECRET"]

  hash_branch :spotify, "rspotify" do |r|
    r.get do
      rspotify_user(session_access_token(r)).instance_variables_hash
    end
  end
  
  hash_branch :spotify, "analyze" do |r|
    r.is "song", String do |id|
      RSpotify::AudioFeatures.find(id).valence.to_s
    end

    r.is "playlist", String do |id|
      pl = RSpotify::Playlist.find_by_id id
      RSpotify::AudioFeatures.find pl.all_tracks 
    end

  end
end
