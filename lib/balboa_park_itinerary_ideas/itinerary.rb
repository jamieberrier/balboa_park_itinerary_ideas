class BalboaParkItineraryIdeas::Itinerary

  attr_accessor :title, :itinerary_url, :summary, :attractions # an array of hashes with names, descriptions, and URLs of the attractions

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

  # formats the description of the attractions for the Birds of Balboa Itinerary
  def self.format_description(attractions_hash)
    attractions_hash.each do |attraction|
      description_array = []

      a1 = attraction[:description].partition(/D\w+:/)
      a2 = a1[2].partition(/\w+ \w+ \w+ \w+:/)
      a3 = a2[2].partition(/N\w+ \w+:/)

      description = Strings.wrap(a1[1] + a2[0] + "\n", 75)
      diet = Strings.wrap("\n" + a2[1] + a3[0] + "\n", 75)
      nesting = Strings.wrap("\n" + a3[1] + a3[2], 75)

      description_array.push(description, diet, nesting)
      attraction[:description] = description_array
    end
  end
end
