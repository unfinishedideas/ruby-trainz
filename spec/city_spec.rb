require 'rspec'
require 'city'
require('spec_helper')

describe '#City' do

  # before(:each) do
  #
  # end

  describe('.all') do
    it("returns an empty array when there are no cities") do
      expect(City.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves a new city to the database") do
      city = City.new({:id => nil, :name => "Jimmy John"})
      city.save()
      expect(City.all).to(eq([city]))
    end
  end

  describe(".clear") do
    it("clears da list") do
      city = City.new({:id => nil, :name => "Jimmy John"})
      city.save()
      City.clear()
      expect(City.all).to(eq([]))
    end
  end

  describe('.find') do
    it("should be able to find a city by id") do
      city = City.new({:id => nil, :name => "Jimmy John"})
      city.save()
      expect(City.find(city.id)).to(eq(city))
    end
  end

  describe('#delete') do
    it('deletes an city by id') do
      city = City.new({:id => nil, :name => "Jimmy John"})
      city2 = City.new({:id => nil, :name => "Seattle"})
      city.save()
      city2.save()
      city.delete()
      expect(City.all).to(eq([city2]))
    end
  end

  describe('#update') do
    it("should be able to update a citys name") do
      city = City.new({:id => nil, :name => "Jimmy John"})
      city.save()
      city.update({:name => "CityTown", :train_name => "Jimmy John", :stop_time => '03:00:00'})
      expect(city.name).to(eq("CityTown"))
    end
  end

  describe('#trains') do
    it("should return a list of trains that a city has") do
      city = City.new({:id => nil, :name => "City Town"})
      city.save()
      train = Train.new({:id => nil, :name => "Thomas"})
      train.save()
      city.update({:name => "City Town", :train_name => "Thomas", :stop_time => '03:00:00'})
      expect(city.trains).to(eq([train]))
    end
  end

end
