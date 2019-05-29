class BalboaParkItineraryIdeas::Scraper
  URL = "https://www.balboapark.org"

  # creates instances of Itinerary with title and url for each itinerary
  def scrape_itineraries
    #@doc = Nokogiri::HTML(open(URL))
    @doc = Nokogiri::HTML(open(URL, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    @doc.css('div.view-itineraries span.field-content').each do |x|

      itinerary = BalboaParkItineraryIdeas::Itinerary.new
      itinerary.title = x.css('a').text
      itinerary.url = URL + x.css('a').attribute("href").value

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

  # gets the itinerary's attrubutes of summary and attractions (name, description & URL) from itinerary's page and returns hash with the attributes
  def scrape_itinerary_page(itinerary_url)
    #itinerary_page = Nokogiri::HTML(open(itinerary_url))
    itinerary_page = Nokogiri::HTML(open(itinerary_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    scraped_details = {}
    # Summary
    if itinerary_url.include?("explorer") # Explorer itinerary summary has a href with jpeg in the summary
      scraped_details[:summary] = get_explorer_summary(itinerary_page)
    else
      scraped_details[:summary] = itinerary_page.css('div.content div.field--type-text-with-summary p').text.strip
    end
    # Attractions
    scraped_details[:attractions] = []
    itinerary_page.css('div.field--name-field-stops div.field--item').each do |attraction|
      # attraction name
      name = attraction.css('div.content').text.delete("\n").strip.split("Attraction").join.strip.split("Description").delete_at(0)
      name.strip! unless name == nil
      # attraction description
      if itinerary_url.include?("birds") # The Birds of Balboa Park itinerary has 3 paragraphs of text
        description = get_birds_attraction_description(attraction)
      else # all other itineraries
        description = attraction.css('p').text
      end
      # URL
      if attraction.css('a').attr('href').nil? # not all attractions have a URL
        attraction_url = ""
      else
        attraction_url = URL + attraction.css('a').attr('href').value
      end

      scraped_details[:attractions].push(name: name, description: description, attraction_url: attraction_url)
      scraped_details[:attractions].reject! { |e|  e[:name] == nil }

    end # end of each
    scraped_details
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
    # The California Thrasher has its latin name as <p> instead of <em> like the rest
    if attraction.css('p').text.include?("Toxostoma")
      d1 = attraction.css('p')[1].text.strip
      d2 = attraction.css('p')[2].text.strip
      d3 = attraction.css('p')[3].text.strip
    else
      d1 = attraction.css('p')[0].text.strip
      d2 = attraction.css('p')[1].text.strip
      # Handles: The Red Shouldered Hawk's 'Nesting habits' has leading whitespace that .strip doesn't remove
      d3 = attraction.css('p')[2].text.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '') # removes leading & trailing spaces
    end
    # formats the 3 paragraphs
    descr = Strings.wrap(d1 + "\n", 86)
    diet = Strings.wrap("\n" + d2 + "\n", 86)
    nesting = Strings.wrap("\n" + d3, 86)

    description_array.push(descr, diet, nesting)
  end
end
