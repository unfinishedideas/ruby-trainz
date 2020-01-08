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

get('/cities') do
  @cities = City.all
  erb(:cities)
end

get('/trains') do
  @trains = Train.all
  erb(:trains)
end

get('/trains/new') do
  erb(:admin_create_train)
end

get('/cities/admin') do
  @cities = City.all
  erb(:admin_cities)
end

get('/trains/admin') do
  @trains = Train.all
  erb(:admin_trains)
end

get('cities/:id/edit') do
  @cities = City.all
  erb(:admin_update_city)
end

get('cities/new') do
  erb(:admin_create_city)
end

get('/admin') do
  erb(:admin)
end

post '/trains/admin' do
  name = params[:train_name]
  @train = Train.new({:id => nil, :name => name})
  @train.save()
  @trains = Train.all()
  erb(:admin_trains)
end

post('/admin/trains') do
  Train.clear()
  erb(:admin_trains)
end

get '/train/:id' do
  @train = Train.find(params[:id])
  @cities = @train.cities
  erb(:train)
end

get '/train/:id/admin' do
  @train = Train.find(params[:id])
  @cities = @train.cities
  erb(:admin_train)
end

post '/train/:id/admin' do
  name = params[:city_name]
  time = (params[:time_input] + ":00")
  city = City.new({:id => nil, :name => name})
  city.save()
  @train = Train.find(params[:id])
  @train.update({:name => @train.name, :city_name => name, :stop_time => time})
  @cities = @train.cities
  erb(:admin_train)
end
