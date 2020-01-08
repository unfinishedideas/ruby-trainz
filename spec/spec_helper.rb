require 'rspec'
require 'pg'
require 'city'
require 'train'
require 'pry'

DB = PG.connect({:dbname => 'train_station_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM cities *;")
    DB.exec("ALTER SEQUENCE cities_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM trains *;")
    DB.exec("ALTER SEQUENCE trains_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM stops *;")
    DB.exec("ALTER SEQUENCE stops_id_seq RESTART WITH 1;")
  end
end
