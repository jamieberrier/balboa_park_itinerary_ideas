class BalboaParkItineraryIdeas::Itinerary

  attr_accessor :title, :itinerary_url, :summary, :attractions # an array of hashes with names & descriptions of the attractions

  @@all = []

  def initialize(itinerary_hash)
    itinerary_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  # creates itinerary instances from an array of scraped itineraries
  def self.create_from_collection(itineraries_array)
    itineraries_array.each do |itinerary|
      BalboaParkItineraryIdeas::Itinerary.new(itinerary)
    end
  end

  # add the itinerary's summary and details of its attractions from a hash of scraped attributes
  def add_itinerary_attributes(itinerary_hash)
    itinerary_hash.each {|key, value| self.send(("#{key}="), value)}
    self
  end

  def self.all
    @@all
  end

  # returns the itinerary that matches the user input
  def self.find(id)
    self.all[id-1]
  end

  # prints the details of each attraction
  def print_attractions
    self.attractions.each do |x|
      puts "#{x[:name]}".bold.red
      puts Strings.wrap(x[:description], 75)
      if x[:attraction_url] != ""
        puts "Click for more info: ".green + "#{x[:attraction_url]}".green.underline
      end
      puts ""
    end
  end
end
