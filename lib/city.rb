class City
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
  end

  def self.all
    returned_cities = DB.exec("SELECT * FROM cities;")
    cities = []
    returned_cities.each() do |city|
      id = city.fetch("id").to_i
      name = city.fetch("name")
      cities.push(City.new({:id => id, :name => name}))
    end
    cities
  end

  def save
    result = DB.exec("INSERT INTO cities (name) VALUES ('#{name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(city)
    self.name().downcase().eql?(city.name().downcase())
  end

  def self.clear
    DB.exec("DELETE FROM cities *;")
    DB.exec("ALTER SEQUENCE cities_id_seq RESTART WITH 1;")
  end

  def self.find(id)
    city = DB.exec("SELECT * FROM cities WHERE id = #{id};").first
    id = city.fetch("id").to_i
    name = city.fetch("name")
    City.new({:id => id, :name => name})
  end

  def delete
    DB.exec("DELETE FROM cities WHERE id = #{@id};")
  end

  def update(user_input)
    if (user_input.has_key?(:name)) && (user_input.fetch(:name) != nil)
      @name = user_input.fetch(:name)
      DB.exec("UPDATE cities SET name = '#{@name}' WHERE id = #{@id};")
    end
    train_name = user_input.fetch(:train_name)
    stop_time = user_input.fetch(:stop_time)
    if train_name != nil
      train = DB.exec("SELECT * FROM trains WHERE lower(name)='#{train_name.downcase}';").first
      if train != nil
        DB.exec("INSERT INTO stops (train_id, city_id, stop_time) VALUES (#{train['id'].to_i}, #{@id}, '#{stop_time}')")
      end
    end
  end

  def trains
    trains_array = []
    results = DB.exec("SELECT train_id FROM stops WHERE city_id = #{@id};")
    results.each() do |result|
      train_id = result.fetch("train_id").to_i()
      train = DB.exec("SELECT * FROM trains WHERE id = #{train_id};")
      name = train.first().fetch("name")
      trains_array.push(Train.new({:name => name, :id => train_id}))
    end
    trains_array
  end

end
