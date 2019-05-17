class BalboaParkItineraryIdeas::Scraper
  URL = "https://www.balboapark.org"

  def self.get_page
    Nokogiri::HTML(open(URL))
  end

  # gets welcome header
  def self.scrape_welcome_header
    self.get_page.css('section#block-welcome h2').text
  end

  # gets welome message
  def self.scrape_welcome_message
    self.get_page.css('section#block-welcome p').text
  end

  # gets 'Itinerary Ideas' header
  def self.scrape_header
    self.get_page.css('section#block-views-block-itineraries-block-1 h2').text
  end

  # gets title and url of each itinerary, pushes attributes into array, and returns array
  def self.scrape_itineraries
    itineraries = []

    self.get_page.css('div.view-itineraries span.field-content').each do |itinerary|
      title = itinerary.css('a').text
      itinerary_url = URL + itinerary.css('a').attribute("href").value

      itineraries.push(title: title, itinerary_url: itinerary_url)
    end
    itineraries
  end

  # gets the itinerary's attrubutes (summary and name & description of the attractions) from itinerary's page and returns hash with the attributes
  def self.scrape_itinerary_page(itinerary_url)
    itinerary_page = Nokogiri::HTML(open(itinerary_url))
    scraped_details = {}

    scraped_details[:summary] = itinerary_page.css('div.content div.field--type-text-with-summary p').text.strip

    scraped_details[:attractions] = []
    itinerary_page.css('div.field--name-field-stops div.field--item').each do |attraction|
        name = attraction.css('div.content').text.delete("\n").strip.split("Attraction").join.strip.split("Description").delete_at(0)
        description = attraction.css('p').text

        if attraction.css('a').attr('href').nil?
          attraction_url = ""
        else
          attraction_url = URL + attraction.css('a').attr('href').value
        end

        scraped_details[:attractions].push(name: name, description: description, attraction_url: attraction_url)#.reject! { |e|  e[:name] == nil }
        scraped_details[:attractions].reject! { |e|  e[:name] == nil }
    end
    
    if itinerary_url.include?("birds")
      BalboaParkItineraryIdeas::Itinerary.format_description(scraped_details[:attractions])
    end
    scraped_details
  end
end
