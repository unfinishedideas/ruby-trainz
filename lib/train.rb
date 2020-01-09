class Train
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
  end

  def self.all
    returned_trains = DB.exec("SELECT * FROM trains;")
    trains = []
    returned_trains.each() do |train|
      id = train.fetch("id").to_i
      name = train.fetch("name")
      trains.push(Train.new({:id => id, :name => name}))
    end
    trains
  end

  def save
    result = DB.exec("INSERT INTO trains (name) VALUES ('#{name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(train)
    self.name().downcase().eql?(train.name().downcase())
  end

  def self.clear
    DB.exec("DELETE FROM trains *;")
    DB.exec("ALTER SEQUENCE trains_id_seq RESTART WITH 1;")
  end

  def self.find(id)
    train = DB.exec("SELECT * FROM trains WHERE id = #{id};").first
    id = train.fetch("id").to_i
    name = train.fetch("name")
    Train.new({:id => id, :name => name})
  end

  def delete
    DB.exec("DELETE FROM stops WHERE train_id = #{@id};")
    DB.exec("DELETE FROM trains WHERE id = #{@id};")
  end

  def update(user_input)
    if (user_input.has_key?(:name)) && (user_input.fetch(:name) != nil)
      @name = user_input.fetch(:name)
      DB.exec("UPDATE trains SET name = '#{@name}' WHERE id = #{@id};")
    end
    city_name = user_input.fetch(:city_name)
    stop_time = user_input.fetch(:stop_time)
    if city_name != nil
      city = DB.exec("SELECT * FROM cities WHERE lower(name)='#{city_name.downcase}';").first
      if city != nil
        DB.exec("INSERT INTO stops (city_id, train_id, stop_time) VALUES (#{city['id'].to_i}, #{@id}, '#{stop_time}')")
      end
    end
  end

  def cities
    cities_array = []
    cities_array_2 = []
    results = DB.exec("SELECT city_id FROM stops WHERE train_id = #{@id};")
    results.each() do |result|
      city_id = result.fetch("city_id").to_i()
      city = DB.exec("SELECT * FROM cities WHERE id = #{city_id};")
      name = city.first().fetch("name")
      cities_array.push(City.new({:name => name, :id => city_id}))
    end
    city_id_array = []
    cities_array.each() do |city|
      city_id_array.push(city.id)
    end
    city_id_array.uniq!
    cities_array.each() do |city|
      if city_id_array.include?(city.id)
        cities_array_2.push(city)
        city_id_array.delete(city.id)
      end
    end
    cities_array_2
  end
end
