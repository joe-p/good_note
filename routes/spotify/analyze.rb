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
      {valence: RSpotify::AudioFeatures.find(id).valence}
    end

    r.is "playlist", String do |id|
      pl = RSpotify::Playlist.find_by_id id
      valences = RSpotify::AudioFeatures.find(pl.all_tracks).map do |t|
        t.valence
      end
      
      {average_valence: valences.sum(0.0)/valences.size}

    end

  end
end
