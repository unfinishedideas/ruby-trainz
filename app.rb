require('sinatra')
require('sinatra/reloader')
require('./lib/train')
require('./lib/city')
require('pry')
require("pg")

DB = PG.connect({:dbname => "train_station"})

# also_reload('lib/**/*.rb')

get('/') do
  erb(:homepage)
end
