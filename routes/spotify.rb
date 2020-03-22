require_relative 'spotify/auth'
require_relative 'spotify/analyze'

class MusicTherapy < Roda
  plugin :hash_routes

  hash_branch "spotify" do |r|
    r.hash_routes(:spotify)
  end 
end
