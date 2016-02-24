require 'sinatra'
require 'sqlite3'
require "multi_json"
require "sinatra/multi_route"
require_relative 'helpers'

class UsdaAPI < Sinatra::Application
  before do
    $db = SQLite3::Database.new 'usdadb.sqlite3'

    # set headers
    headers 'Content-Type' => 'application/json; charset=utf8'
    headers 'Access-Control-Allow-Methods' => 'HEAD, GET'
    headers 'Access-Control-Allow-Origin' => '*'
    cache_control :public, :must_revalidate, max_age: 60
  end

  # prohibit certain methods
  route :put, :delete, :copy, :options, :trace, '/*' do
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
        "/search (GET)",
        "/heartbeat"
      ]
    })
  end

  # route listing route
  get '/search/?' do
    get_species
  end

  def get_species
    limit = params[:limit] || 10
    fields = params[:fields] || '*'
    res = $db.execute2("select %s from usda limit %s" % [fields, limit])
    cols = res[0]
    res.delete_at(0)
    res = res.collect { |x| Hash[cols.zip(x.to_a)] }
    return MultiJson.dump(res)
  end
end
