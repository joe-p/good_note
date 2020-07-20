require 'faraday'
require 'json'

HOST = 'http://do.jpolny.net'.freeze

describe 'GoodNote' do
  context 'when sending a GET request to an API endpoint' do
    it 'returns JSON data' do
      get_request = Faraday.get(HOST + '/spotify/analyze/recommendations?genres=hip-hop,classical')

      parsed_output = JSON.parse get_request.body

      expect(parsed_output).to be_an_instance_of(Hash).or be_an_instance_of(Array)
    end
  end
end
