class BalboaParkItineraryIdeas::Itinerary

  attr_accessor :title, :url, :summary, :attractions # an array of hashes with names, descriptions, and URLs of the attractions

  @@all = []

  def self.new_from_hash(itinerary_hash)
    itinerary_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def save
    @@all << self
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
end
