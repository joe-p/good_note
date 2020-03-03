require "roda"
require 'rspotify'
require 'cgi'
require 'faraday'

require_relative 'db'
require_relative 'models'

class MusicTherapy < Roda

  plugin :json, classes: [Array, Hash, Sequel::Model]
  plugin :public
  plugin :render

  HOSTNAME = ( ENV["RACK_HOST"] || "http://localhost:9292" )

  CLIENT_ID = ENV["CLIENT_ID"]
  CLIENT_SECRET = ENV["CLIENT_SECRET"]

  RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)

  route do |r|
    # Allows static files (ie. favicon.ico) to be found in /public
    r.public

    r.is "users" do
      r.post do
        User.create r.params
      end

      r.get do
        User.all
      end
    end

    r.is "spotify/auth" do

      # Bring user to Spotify login page
      r.redirect (
        "https://accounts.spotify.com/authorize?" +
        "client_id=#{CLIENT_ID}&" +
        "response_type=code&" +
        "state=test_state&" +
        "redirect_uri=" +
        CGI.escape("#{HOSTNAME}/spotify/auth/callback")
      )
    end

    r.is "spotify/auth/callback" do 

      if r.params["code"]
        User.authenticate_via_spotify r.params["code"] 
      
      # Authorization failed (redirected to callback with error parameter)
      elsif r.params["error"]
        "Authorization failed due to the following error: #{r.params["error"]}"

      # Authorization failed (redirect did not contain code or error)
      else
        "Authorization failed due to an unknwon reason (unknown parameters)"

      end

    end

    r.on "spotify/api" do

      # /spotify/api/v1
      r.on "v1" do  
        #insert our own API endpoints here
      end

    end

  end
end
