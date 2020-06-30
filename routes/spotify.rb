require_relative 'spotify/auth'
require_relative 'spotify/analyze'

class GoodNote < Roda
  plugin :hash_routes
  plugin :request_headers

  def rspotify_user(token)
    me_res = Faraday.new.get('https://api.spotify.com/v1/me', nil, { 'Authorization' => "Bearer #{token}" })
    me_hash = JSON.parse(me_res.body)

    init_hash = me_hash.dup
    init_hash['credentials'] = { 'token' => token }

    RSpotify::User.new init_hash
  end

  def access_token(r)
    if r.headers['Authorization']
      r.headers['Authorization'].split.last
    elsif r.session['auth_info']
      r.session['auth_info']['access_token']
    end
  end

  hash_branch 'spotify' do |r|
    r.hash_routes(:spotify)
  end
end
