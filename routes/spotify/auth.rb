class MusicTherapy < Roda
  plugin :hash_routes

  hash_path :spotify, "/auth" do |r|
    r.get do
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
  end

  hash_branch :spotify, "auth" do |r|

    # /spotify/auth/callback 
    r.is "callback" do

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

    # /spotify/auth/refresh
    r.is "refresh" do
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
  end
end
