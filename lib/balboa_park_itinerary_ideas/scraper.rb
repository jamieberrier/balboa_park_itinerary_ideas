class BalboaParkItineraryIdeas::Scraper
  URL = "https://www.balboapark.org"

  # creates instances of Itinerary with title, url, and empty attractions array for each itinerary
  def scrape_itineraries
    @doc = Nokogiri::HTML(open(URL))
    #@doc = Nokogiri::HTML(open(URL, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)) # use if security certificate is expired
    @doc.css('div.view-itineraries span.field-content').each do |it|
      itinerary = BalboaParkItineraryIdeas::Itinerary.new

      itinerary.title = it.css('a').text
      itinerary.url = URL + it.css('a').attribute("href").value
      itinerary.attractions = []

      itinerary.save
    end
  end

  # gets welcome header
  def scrape_welcome_header
    @doc.css('section#block-welcome h2').text
  end

  # gets welome message
  def scrape_welcome_message
    @doc.css('section#block-welcome p').text
  end

  # gets 'Itinerary Ideas' header
  def scrape_header
    @doc.css('section#block-views-block-itineraries-block-1 h2').text
  end

  # gets the itinerary's summary and attractions (name, description & URL) from the itinerary's page, adds to itinerary instance, and returns itinerary instance
  def scrape_itinerary_page(itinerary)
    #itinerary_page = Nokogiri::HTML(open(itinerary_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)) # use if security certificate is expired
    itinerary_page = Nokogiri::HTML(open(itinerary.url))
    # Summary
    if itinerary.title.include?("Explorer") # Explorer itinerary summary has a href with jpeg in the summary
      itinerary.summary = get_explorer_summary(itinerary_page)
    else
      itinerary.summary = itinerary_page.css('div.content div.field--type-text-with-summary p').text.strip
    end
    # Attractions
    itinerary_page.css('div.field--name-field-stops div.field--item').collect do |attraction|
      # attraction name
      name = attraction.css('div.content').text.delete("\n").strip.split("Attraction").join.strip.split("Description").delete_at(0)
      name.strip! unless name == nil
      # attraction description
      if itinerary.title.include?("Birds") # The Birds of Balboa Park itinerary has 3 paragraphs of text
        description = get_birds_attraction_description(attraction)
      else # all other itineraries
        description = attraction.css('p').text
      end
      # URL
      unless attraction.css('a').attr('href').nil? # not all attractions have a URL
        attraction_url = URL + attraction.css('a').attr('href').value
      end
      # pushes hash of attraction details on to attractions array
      itinerary.attractions.push(name: name, description: description, attraction_url: attraction_url)
      itinerary.attractions.reject! { |e|  e[:name] == nil } # reject duplicates
    end # end of collect
    itinerary
  end

  # Handles that the Explorer itinerary summary has a href with jpeg in its summary
  def get_explorer_summary(itinerary_page)
    summary = itinerary_page.css('div.content div.field--type-text-with-summary p')
    node = summary.css('a')[0]
    node.content = "Explorer Pass"
    summary.text.strip
  end

  # Handles that the Birds of Balboa Park itinerary has 3 paragraphs of text
  def get_birds_attraction_description(attraction)
    description_array = []
    # Handles that the California Thrasher has its latin name as <p> instead of <em> like the rest of the birds
    if attraction.css('p').text.include?("Toxostoma")
      d1 = attraction.css('p')[1].text.strip
      d2 = attraction.css('p')[2].text.strip
      d3 = attraction.css('p')[3].text.strip
    else
      d1 = attraction.css('p')[0].text.strip
      d2 = attraction.css('p')[1].text.strip
      # Handles the Red Shouldered Hawk's 'Nesting habits' leading whitespace that .strip doesn't remove
      d3 = attraction.css('p')[2].text.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '') # removes leading & trailing spaces
    end
    # formats the 3 paragraphs
    descr = Strings.wrap(d1 + "\n", 86)
    diet = Strings.wrap("\n" + d2 + "\n", 86)
    nesting = Strings.wrap("\n" + d3, 86)
    # pushes paragraphs on to array
    description_array.push(descr, diet, nesting)
  end
end
