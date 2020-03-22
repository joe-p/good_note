class MusicTherapy < Roda
  plugin :hash_routes

  def get_audio_features(ids, session)
    if !ids.is_a? Array
      ids = [ids]
    end

    api_conn = Faraday.new("https://api.spotify.com/v1/")

    features_array= []

    ids.each_slice(100) do |id_arr|
      ids_str = id_arr.join(",")

      features_res = api_conn.get("audio-features?ids=#{ids_str}") do |req|
        req.headers = {"Authorization" => "Bearer #{session['auth_info']['access_token']}"}
      end

      JSON.parse(features_res.body)["audio_features"].each do |f|
        features_array << f
      end
    end

    return features_array
  end

  hash_branch :spotify, "analyze" do |r|
    r.is "song", String do |id|
      get_audio_features(id, r.session)
    end

    r.is "playlist", String do |id|
      api_conn = Faraday.new("https://api.spotify.com/v1/")

      res = api_conn.get("playlists/#{id}/tracks") do |req|
        req.headers = {"Authorization" => "Bearer #{r.session['auth_info']['access_token']}"}
      end

      track_ids = [] 

      JSON.parse(res.body)["items"].each do |item|
        track_ids << item["track"]["id"]
      end

      relevant_keys = [
        "duration_ms" ,
        "key" ,
        "mode" ,
        "time_signature" ,
        "acousticness" ,
        "danceability" ,
        "energy" ,
        "instrumentalness" ,
        "liveness" ,
        "loudness" ,
        "speechiness" ,
        "valence" ,
        "tempo"
      ]

      feature_hash = get_audio_features(track_ids, r.session)

    end

  end
end
