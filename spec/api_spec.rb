require_relative 'spec_helper'

describe API do
  before(:each) do
    allow(Models).to receive(:list_fields).and_return %w(foo bar baz)
    Models.models.each do |model_name|
      model = Models.const_get(model_name)
      allow(model).to receive(:endpoint).and_return %w(foo bar baz)
    end
  end

  Models.models.each do |model_name|
    it "exposes #{model_name.to_s}" do
      get "/#{model_name.to_s.downcase}/?limit=3"
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body)
      expect(body['count']).to be > 0
      expect(body['returned']).to eq 3
      expect(body['data'].length).to eq 3
      expect(body['error']).to be_nil
    end
  end

  it 'lists endpoints' do
    get '/heartbeat'
    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)['routes'].length).to eq Models.models.length + 4
  end

  it 'redirects root to heartbeat' do
    get '/'
    expect(last_response).to be_redirect
    expect(last_response.location).to eq 'http://example.org/heartbeat'
  end

  context 'shows docs' do
    subject { get '/docs'; last_response }
    it { is_expected.to be_ok }
  end

  context 'pings the db' do
    subject { get '/mysqlping'; last_response }
    it { is_expected.to be_ok }
  end

  context 'lists fields' do
    subject { get '/listfields'; last_response }
    it { is_expected.to be_ok }
  end
end
