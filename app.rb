require('sinatra')
require('sinatra/reloader')
require('./lib/train')
require('./lib/city')
require('pry')
require("pg")
also_reload('lib/**/*.rb')


DB = PG.connect({:dbname => "train_station"})


get('/') do
  erb(:homepage)
end

############################################# User
############################## Trains
get('/trains') do
  @trains = Train.all
  erb(:trains)
end

get '/train/:id' do
  @train = Train.find(params[:id])
  @cities = @train.cities
  erb(:train)
end

############################## Cities
get('/cities') do
  @cities = City.all
  erb(:cities)
end

get '/city/:id' do
  @city = City.find(params[:id])
  @trains = @city.trains
  erb(:city)
end

############################################# Admin!
get '/password' do
  erb(:password)
end

post '/admin' do
  input = params[:password]
  if input === "chickens"
    erb(:admin)
  else
    erb(:access_denied)
  end
end

get('/admin') do
  erb(:admin)
end

############################## Trains
get('/trains/new') do
  erb(:admin_create_train)
end

get('/train/:id/update') do
  @train = Train.find(params[:id])
  erb(:admin_update_train)
end

get('/trains/admin') do
  @trains = Train.all
  erb(:admin_trains)
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

get '/train/:id/admin' do
  @train = Train.find(params[:id])
  @all_cities = City.all
  @cities = @train.cities
  erb(:admin_train)
end

post '/train/:id/admin' do
  name = params[:city_name]
  time = (params[:time_input] + ":00")
  @train = Train.find(params[:id])
  @all_cities = City.all
  @train.update({:name => @train.name, :city_name => name, :stop_time => time})
  @cities = @train.cities
  erb(:admin_train)
end

delete '/train/:id/admin' do
  @train = Train.find(params[:id].to_i())
  @train.delete()
  @trains = Train.all()
  erb(:admin_trains)
end

patch('/trains/:id/admin') do
  @train = Train.find(params[:id].to_i())
  @cities = @train.cities
  @all_cities = City.all
  @train.update({:name => params[:name], :city_name => nil, :stop_time => nil})
  erb(:admin_train)
end

############################## Cities
get('/cities/admin') do
  @cities = City.all
  erb(:admin_cities)
end

get('/cities/new') do
  erb(:admin_create_city)
end

post '/cities/admin' do
  name = params[:city_name]
  @city = City.new({:id => nil, :name => name})
  @city.save()
  @cities = City.all()
  erb(:admin_cities)
end

get('/city/:id/update') do
  @city = City.find(params[:id])
  erb(:admin_update_city)
end

get '/city/:id/admin' do
  @city = City.find(params[:id])
  @trains = @city.trains
  @all_trains = Train.all
  erb(:admin_city)
end

post '/city/:id/admin' do
  @all_trains = Train.all
  name = params[:train_name]
  time = (params[:time_input] + ":00")
  @city = City.find(params[:id])
  @city.update({:name => @city.name, :train_name => name, :stop_time => time})
  @trains = @city.trains
  erb(:admin_city)
end

patch('/cities/:id/admin') do
  @all_trains = Train.all
  @city = City.find(params[:id].to_i())
  @trains = @city.trains
  name = params[:name]
  @city.update({:name => name, :train_name => nil, :stop_time => nil})
  erb(:admin_city)
end

delete '/city/:id/admin' do
  @city = City.find(params[:id].to_i())
  @city.delete()
  @cities = City.all()
  erb(:admin_cities)
end
