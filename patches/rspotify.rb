module Patches
  module RSpotifyPatches
    module PlaylistPatches
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
    module AudioFeaturesClassPatches

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

RSpotify.send :prepend, Patches::RSpotifyPatches::AudioFeaturesClassPatches
