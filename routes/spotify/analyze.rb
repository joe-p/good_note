require 'rspotify'

class GoodNote < Roda
  plugin :hash_routes
  plugin :static, ['/images', '/css', '/js']
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

      valences = RSpotify::AudioFeatures.find(pl.all_tracks).map(&:valence)

      danceabilities = RSpotify::AudioFeatures.find(pl.all_tracks).map(&:danceability)

      tempos = RSpotify::AudioFeatures.find(pl.all_tracks).map(&:tempo)

      valence = valences.sum(0.0) / valences.size
      danceability = danceabilities.sum(0.0) / danceabilities.size
      tempo = tempos.sum(0.0) / tempos.size
      seed_tracks = pl.tracks(limit: 5).map(&:id)

      recommendations = RSpotify::Recommendations.generate(limit: 50, seed_tracks: seed_tracks, target_valence: valence, target_danceability: danceability, target_tempo: tempo).tracks

      # Add option asking if the user wants to create a playlist
      pl2 = rspotify_user(access_token(r)).create_playlist!('recs')
      pl2.add_tracks!(recommendations)

      { recommendations: recommendations.map(&:name) }
    end

    r.is 'recommendations' do

      parameters = {}

      parameters[:seed_genres] = r.params['genres'].split(',') if r.params['genres']
      parameters[:seed_artists] = r.params['artists'].split(',') if r.params['artists']
      parameters[:seed_tracks] = r.params['tracks'].split(',') if r.params['tracks']
      parameters[:target_valence] = r.params['valence'].to_f if r.params['valence']
      parameters[:target_tempo] = r.params['tempo'].to_f if r.params['tempo']
      parameters[:target_energy] = r.params['energy'].to_f if r.params['energy']

      puts parameters # output to STDOUT for debugging purposes

      recommendations_object = RSpotify::Recommendations.generate(parameters)

      recommendation_hash = {}

      recommendations_object.tracks.each do |t|
        recommendation_hash[t.artists.first.name] ||= {}
        recommendation_hash[t.artists.first.name][t.name] = t.external_urls
      end

      Activity.create(
        patient_id: rspotify_user(access_token(r)).id,
        response: recommendation_hash.to_s,
        request: r.path + '?' + r.query_string,
        time: Time.now
      )

      recommendation_hash
    end
  end
end
