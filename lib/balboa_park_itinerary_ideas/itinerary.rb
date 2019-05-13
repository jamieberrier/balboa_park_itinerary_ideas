class BalboaParkItineraryIdeas::Itinerary
  attr_accessor :name, :url, :header, :summary, :info # add attributes from itinerary's page

  @@all = []

  def initialize(itinerary_hash)
    itinerary_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(itineraries_array)
    itineraries_array.each do |itinerary|
      BalboaParkItineraryIdeas::Itinerary.new(itinerary)
    end
  end

  def self.all
    @@all
  end

  def self.find(id)
    self.all[id-1]
  end

  # Itinerary's page
  def doc
    # refactor...add 'https://www.balboapark.org' to itinerary url
    @doc ||= Nokogiri::HTML(open('https://www.balboapark.org' + self.url))
  end

  def header
    @header ||= doc.css('h1.page-header').text.strip
  end

  def summary
    @summary ||= doc.css('div.content div.field--type-text-with-summary p').text.strip
  end

  # add URL for each attraction, if exists
  def info
    info = []

    doc.css('div.field--name-field-stops div.field--item').each do |attraction|
        description = attraction.css('p').text
        name = attraction.css('div.content').text.delete("\n").strip.split("Attraction").join.strip.split("Description").delete_at(0)

        info.push(name: name, description: description)
    end
    info.reject! { |e|  e[:name] == nil}
  end

  def print_info
    info.each do |x|
      puts "#{x[:name]}".bold
      puts "#{x[:description]}"
      puts ""
    end
  end
end
