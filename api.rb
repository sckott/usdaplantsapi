require 'sinatra'
require 'sqlite3'
require "multi_json"
require "sinatra/multi_route"
require 'active_record'
require_relative 'helpers'
require_relative 'model'

ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'w'))

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'usdadb.sqlite3'
)

class UsdaAPI < Sinatra::Application
  before do
    # set headers
    headers 'Content-Type' => 'application/json; charset=utf8'
    headers 'Access-Control-Allow-Methods' => 'HEAD, GET'
    headers 'Access-Control-Allow-Origin' => '*'
    cache_control :public, :must_revalidate, max_age: 60
  end

  # prohibit certain methods
  route :put, :post, :delete, :copy, :options, :trace, '/*' do
    halt 405
  end

  # handle missed route
  not_found do
    halt 404, MultiJson.dump({ error: 'route not found' })
  end

  # handle other errors
  error do
    halt 500, MultiJson.dump({ error: 'server error' })
  end

  # default to heartbeat
  get '/' do
    redirect '/heartbeat'
  end

  get "/heartbeat/?" do
    return MultiJson.dump({
      "routes" => [
        "/search (HEAD, GET)",
        "/heartbeat"
      ]
    })
  end

  get '/search/?' do
    get_data_ar
  end

  # helpers  --------
  def get_data_ar
    begin
      data = Usda.endpoint(params)
      raise Exception.new('no results found') if data.length.zero?
      { count: data.limit(nil).count(1), returned: data.length, data: data, error: nil }.to_json
    rescue Exception => e
      halt 400, { count: 0, returned: 0, data: nil, error: { message: e.message }}.to_json
    end
  end

end
