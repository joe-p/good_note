require 'faraday'
require 'json'
require 'faraday_middleware'

HOST = 'http://do.jpolny.net'.freeze

describe 'GoodNote' do
  context 'when sending a GET request to an API endpoint' do
    it 'returns JSON data' do
      get_request = Faraday.get(HOST + '/spotify/analyze/recommendations?genres=hip-hop,classical')

      parsed_output = JSON.parse get_request.body

      expect(parsed_output).to be_an_instance_of(Hash).or be_an_instance_of(Array)
    end
  end

  context "when sending a GET request to an webpage URL" do
    it "renders an HTML document" do
      get_request = Faraday.new.get(HOST + '/session/activity')
      expect(get_request.body).to include("<!DOCTYPE html>")
    end
  end

  context "When sending a POST request to an webpage URL" do
    it "redirects to an HTML document" do
      connection = Faraday.new(:url => HOST + '/session/notes') do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter Faraday.default_adapter
      end
      
      res = connection.post do |req|
        req.headers['Content-Type'] = 'application/json'
      end

      expect(res.body).to include("<!DOCTYPE html>")
    end
  end
end