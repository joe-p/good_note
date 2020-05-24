#!/usr/bin/env ruby

require 'rspotify'
require_relative '../patches/rspotify.rb'

RSpotify.authenticate ENV['CLIENT_ID'], ENV['CLIENT_SECRET']

def song(id)
  { valence: RSpotify::AudioFeatures.find(id).valence }
end

def playlist(id)
  pl = RSpotify::Playlist.find_by_id id
  valences = RSpotify::AudioFeatures.find(pl.all_tracks).map(&:valence)

  { average_valence: valences.sum(0.0) / valences.size }
end

out = {}

out['song'] = song('1lVdoj9vDMPazY4L5NWreC')
out['playlist'] = playlist('1EQ50z1ImtykjACpXunMbe')

out.each do |function_name, output|
  puts "*****#{function_name}*****"
  puts output
  puts ''
end
