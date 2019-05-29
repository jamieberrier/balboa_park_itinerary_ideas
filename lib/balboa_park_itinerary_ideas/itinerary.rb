class BalboaParkItineraryIdeas::Itinerary
  attr_accessor :title, :url, :summary, :attractions # an array of hashes with names, descriptions, and URLs of the attractions

  @@all = []

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  # returns the itinerary that matches the user input
  def self.find(id)
    self.all[id-1]
  end
end
