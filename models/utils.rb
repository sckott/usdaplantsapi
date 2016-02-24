def get_count(table, string)
  query = sprintf("SELECT count(*) as ct FROM %s %s", table, string)
  res = $client.query(query, :as => :json)
  res.collect{ |row| row }[0]["ct"]
end
