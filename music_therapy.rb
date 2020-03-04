require "roda"
require 'cgi'
require 'faraday'

require_relative 'db'
require_relative 'models'

class MusicTherapy < Roda

  plugin :json, classes: [Array, Hash, Sequel::Model]
  plugin :public
  plugin :render
  plugin :sessions, secret: "secrets are fun woijfpowijefopwijepofwijeofijewofijewoijfwoeiwjeifo"

  HOSTNAME = ( ENV["RACK_HOST"] || "http://localhost:9292" )

  CLIENT_ID = ENV["CLIENT_ID"]
  CLIENT_SECRET = ENV["CLIENT_SECRET"]

  route do |r|
    # Allows static files (ie. favicon.ico) to be found in /public
    r.public

    r.on "user", Integer do |user_id|
      User[user_id]
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
        clear_session
        
        current_user, auth_info = User.authenticate_via_spotify( r.params["code"] )

        session["user_id"] = current_user.values[:id]
        session["auth_info"] = auth_info

        r.persist_session({}, session)

        r.redirect("/user/#{current_user.values[:id]}")

      # Authorization failed (redirected to callback with error parameter)
      elsif r.params["error"]
        "Authorization failed due to the following error: #{r.params["error"]}"

      # Authorization failed (redirect did not contain code or error)
      else
        "Authorization failed due to an unknwon reason (unknown parameters)"

      end

    end

    r.is "spotify/auth/refresh" do
      session = r.session

      b64 = Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}")

      api_conn = Faraday.new("https://accounts.spotify.com/api/")

      session["auth_info"] = api_conn.post("token") do |req|
        req.headers = {"Authorization" => "Basic #{b64}"}
        req.body = {
          "grant_type" => "refresh_token", 
          "refresh_token" => session["auth_info"]["refresh_token"]
        }
      end

      r.persist_session({}, session)

      r.redirect("/user/#{session["user_id"]}")
    end

    r.on "spotify/api" do

      # /spotify/api/v1
      r.on "v1" do  
        #insert our own API endpoints here
      end

    end

  end
end
