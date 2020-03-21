require_relative 'spotify/auth'

class MusicTherapy < Roda
  plugin :hash_routes

  hash_branch "spotify" do |r|
    r.hash_routes(:spotify)
  end 
end
