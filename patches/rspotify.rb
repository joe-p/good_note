module Patches

  # Contains patches for classes in the RSpotify gem
  module RSpotifyPatches
  
    # Contains patches for RSpotify::Playlist instance methods
    module PlaylistPatches
      
      # New method that gets all the tracks in a playlist, even if it exceeds the API limit of 100
      # @return [Array<RSpotify::Tracks>]
      def all_tracks
        tracks = []

        ( 0..(self.total / 100) ).each do |x|
          offset = (x * 100)
          tracks += self.tracks(limit: 100, offset: offset)
        end

        return tracks
      end
    end
  end
end

module Patches
  module RSpotifyPatches

    # Contains patches for RSpotify::AudioFeatures class methods
    module AudioFeaturesClassPatches

      # Patched for two new functionalities.
      # 1. It can take an RSpotify::Track instance (or array of RSpotify::Track instances) as an input (opposed to just the id)
      # 2. It will get the audio features for all tracks, even if the count exceeds the API limit of 100
      def find(param)
        if param.is_a? RSpotify::Track
          param = param.id

          return super param

        elsif param.is_a? String
          return super param

        elsif param.is_a? Array
          param.map! do |obj|
            if obj.is_a? RSpotify::Track
              obj.id
            end
          end

          features_array = []

          param.each_slice(100).each do |ids|
            features_array += super ids
          end

          return features_array
        end

      end
    end
  end
end

class RSpotify::Playlist
  prepend Patches::RSpotifyPatches::PlaylistPatches
end

RSpotify::AudioFeatures.singleton_class.send :prepend, Patches::RSpotifyPatches::AudioFeaturesClassPatches
