require 'rspotify'

class RSpotify::Playlist
  def all_tracks
     
    tracks = []

    ( 0..(self.total / 100) ).each do |x|
      offset = (x * 100)
      tracks += self.tracks(limit: 100, offset: offset)
    end

    return tracks
  end
end

class RSpotify::AudioFeatures
  class << self
    alias_method :og_find, :find

    def find(param)
      if param.is_a? RSpotify::Track
        param = param.id
      
        return og_find param
     
      elsif param.is_a? String
        return og_find param

      elsif param.is_a? Array
        param.map! do |obj|
          if obj.is_a? RSpotify::Track
            obj.id
          end
        end
        
        features_array = []

        param.each_slice(100).each do |ids|
          features_array += og_find ids
        end

        return features_array
      end

    end
  end
end

class MusicTherapy < Roda

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
