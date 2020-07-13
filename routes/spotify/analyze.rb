require 'rspotify'

class GoodNote < Roda
  plugin :hash_routes
  plugin :static, ["/images", "/css", "/js"]
  plugin :render

  RSpotify.authenticate ENV['CLIENT_ID'], ENV['CLIENT_SECRET']

  hash_branch :spotify, 'rspotify' do |r|
    r.get do
      rspotify_user(access_token(r)).instance_variables_hash
    end
  end

  hash_branch :spotify, 'analyze' do |r|
    r.is 'song', String do |id|
      { valence: RSpotify::AudioFeatures.find(id).valence }
    end

    r.is 'playlist', String do |id|
      pl = RSpotify::Playlist.find_by_id id

      valences = RSpotify::AudioFeatures.find(pl.all_tracks).map do |t|
        t.valence
      end
      danceabilities = RSpotify::AudioFeatures.find(pl.all_tracks).map do |t|
        t.danceability
      end
      tempos = RSpotify::AudioFeatures.find(pl.all_tracks).map do |t|
        t.tempo
      end

      valence = valences.sum(0.0) / valences.size
      danceability = danceabilities.sum(0.0) / danceabilities.size
      tempo = tempos.sum(0.0) / tempos.size
      seed_tracks = pl.tracks(limit: 5).map do |t|
        t.id
      end

      recommendations = RSpotify::Recommendations.generate(limit: 50, seed_tracks: seed_tracks, target_valence: valence, target_danceability: danceability, target_tempo: tempo).tracks

      # Add option asking if the user wants to create a playlist
      pl2 = rspotify_user( access_token(r) ).create_playlist!('recs')
      pl2.add_tracks!(recommendations)

      { recommendations: recommendations.map do |t|
        t.name
      end }
    end

    r.is "filter", String, Integer, Integer, Integer do |seed_genre, target_valence, target_energy, target_tempo|
      target_valence /= 100
      target_tempo /= 100
      recommendations = RSpotify::Recommendations.generate(seed_genres: [seed_genre], target_valence: target_valence, target_energy: target_energy, target_tempo: target_tempo).tracks.map do |t|
        t.name
      end
      {recommendations: recommendations}
    end
  end
end
