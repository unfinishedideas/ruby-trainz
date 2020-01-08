require 'rspec'
require 'train'
require 'city'
require('spec_helper')

describe '#Train' do

  # before(:each) do
  #
  # end

  describe('.all') do
    it("returns an empty array when there are no cities") do
      expect(Train.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves a new train to the database") do
      train = Train.new({:id => nil, :name => "Jimmy John"})
      train.save()
      expect(Train.all).to(eq([train]))
    end
  end

  describe(".clear") do
    it("clears da list") do
      train = Train.new({:id => nil, :name => "Jimmy John"})
      train.save()
      Train.clear()
      expect(Train.all).to(eq([]))
    end
  end

  describe('.find') do
    it("should be able to find a train by id") do
      train = Train.new({:id => nil, :name => "Jimmy John"})
      train.save()
      expect(Train.find(train.id)).to(eq(train))
    end
  end

  describe('#delete') do
    it('deletes an train by id') do
      train = Train.new({:id => nil, :name => "Jimmy John"})
      train2 = Train.new({:id => nil, :name => "Seattle"})
      train.save()
      train2.save()
      train.delete()
      expect(Train.all).to(eq([train2]))
    end
  end

  describe('#update') do
    it("should be able to update a trains name") do
      train = Train.new({:id => nil, :name => "Jimmy John"})
      train.save()
      train.update({:name => "Jenny Jim", :city_name => nil, :stop_time => '00:00:00'})
      expect(train.name).to(eq("Jenny Jim"))
    end
  end

  describe('#cities') do
    it("should return a list of cities that a train has") do
      train = Train.new({:id => nil, :name => "Jimmy John"})
      train.save()
      city = City.new({:id => nil, :name =>"CityTown"})
      city.save()
      train.update({:name => "Jenny Jim", :city_name => "CityTown", :stop_time => '00:00:00'})
      expect(train.cities).to(eq([city]))
    end
  end

end
