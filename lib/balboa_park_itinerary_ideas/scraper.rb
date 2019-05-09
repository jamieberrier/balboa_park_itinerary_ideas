class BalboaParkItineraryIdeas::Scraper

  def self.get_page
    Nokogiri::HTML(open("https://www.balboapark.org"))
  end

  def self.scrape_itineraries
    itineraries = []

    self.get_page.css('div.view-itineraries span.field-content').each do |itinerary|
      itineraries.push(name: itinerary.css('a').text, url: itinerary.css('a').attribute("href").value)
    end
    itineraries
  end
end
=begin
    def self.print_list
      self.get_page.css('div.view-itineraries span.field-content').each.with_index(1) do |itinerary, i|
        itinerary_name = itinerary.css('a').text
        puts " #{i}. #{itinerary_name}"
      end
    end
=end
=begin
  # scrape an itinerary's page to get further information about that itinerary.
  def self.scrape_itinerary_page#(itinerary_url)
    itinerary_url = "https://www.balboapark.org/itinerary/eccentric"
    itinerary_page = Nokogiri::HTML(open(itinerary_url))
    details = []

    details.push(header: itinerary_page.css('h1.page-header').text.strip)
    details.push(summary: itinerary_page.css('div.content div.field--type-text-with-summary p').text.strip)
    details.push(url: itinerary_url)

    #itinerary_page.css('div.field--items p').text

    details
  end
=end
