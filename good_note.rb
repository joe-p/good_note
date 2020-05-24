require 'roda'
require 'cgi'
require 'faraday'

require_relative 'db'
require_relative 'models'
require_relative 'routes'
require_relative 'patches'

class GoodNote < Roda
  plugin :json, classes: [Array, Hash, Sequel::Model]
  plugin :public
  plugin :render
  plugin :sessions, secret: 'secrets are fun woijfpowijefopwijepofwijeofijewofijewoijfwoeiwjeifo'
  plugin :hash_routes

  HOSTNAME = (ENV['RACK_HOST'] || 'http://localhost:9292')

  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']

  route do |r|
    # Allows static files (ie. favicon.ico) to be found in /public
    r.public

    r.hash_routes
  end
end
