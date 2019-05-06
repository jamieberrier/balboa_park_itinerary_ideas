class BalboaParkItineraryIdeas::Scraper

  def self.get_page
    Nokogiri::HTML(open("https://www.balboapark.org"))
  end

  def self.print_list
    self.get_page.css('div.view-itineraries span.field-content').each.with_index(1) do |event, i|
      event_name = event.css('a').text
      puts " #{i}. #{event_name}"
    end
  end

  def self.scrape_itineraries
    itineraries = []

    self.get_page.css('div.view-itineraries span.field-content').each do |itinerary|
      itineraries.push(name: itinerary.css('a').text, url: itinerary.css('a').attribute("href").value)
    end
    itineraries
  end

  # scrape an itinerary's page to get further information about that itinerary.
  def self.scrape_event_page(event_url)
    event_page = Nokogiri::HTML(open(event_url))
  end
end
