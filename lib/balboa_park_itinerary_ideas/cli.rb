# The CLI Controller - responsible for business logic/user interactions
class BalboaParkItineraryIdeas::CLI

  def call
    make_itineraries
    add_attributes_to_itineraries
    welcome_message
    list_itineraries
    menu
  end

  # makes instances of Itinerary using an array of itineraries scraped from URL
  def make_itineraries
    itineraries_array = BalboaParkItineraryIdeas::Scraper.scrape_itineraries
    BalboaParkItineraryIdeas::Itinerary.create_from_collection(itineraries_array)
  end

  # add individual itinerary attributes scraped from the individual itinerary's page
  def add_attributes_to_itineraries
    BalboaParkItineraryIdeas::Itinerary.all.each do |itinerary|
      attributes = BalboaParkItineraryIdeas::Scraper.scrape_itinerary_page(BalboaParkItineraryIdeas::Scraper::URL + itinerary.itinerary_url)
      itinerary.add_itinerary_attributes(attributes)
    end
  end

  # display welome message scrape from balboapark.org
  def welcome_message
    puts "------------------------------------------------------------------------------"
    puts "#{BalboaParkItineraryIdeas::Scraper.scrape_welcome_header}".blue.bold
    puts "#{BalboaParkItineraryIdeas::Scraper.scrape_welcome_message}"
    puts "------------------------------------------------------------------------------"
  end

  # lists the itineraries for the user to choose from
  # add: scrape "Itinerary Ideas" from page
  def list_itineraries
    puts "Itinerary Ideas:".blue.bold
    BalboaParkItineraryIdeas::Itinerary.all.each.with_index(1) do |itinerary, i|
      puts "#{i}.".green.bold + " #{itinerary.title}".bold
    end
  end

  # displays the user's choices, gets the user's input, and either displays details of an itinerary, the list of itineraries, or exits
  def menu
    input = nil
    while input != "exit"
      puts "-------------------------------------------------------------------"
      puts "What would you like to do? Your choices are:".yellow.bold
      puts "Type the itinerary number " + "('1', '2', '3'....'9')".red.bold + " to see the details"
      puts "Type " + "list".red.bold + " to see the list again"
      puts "Type " + "exit".red.bold
      puts "-------------------------------------------------------------------"

      input = gets.strip.downcase

      if input.to_i > 0 && input.to_i <= 9
        itinerary = BalboaParkItineraryIdeas::Itinerary.find(input.to_i)
        print_details(itinerary)
      elsif input == "list"
        list_itineraries
      elsif input == "exit"
        goodbye
      else
        puts "Didn't understand, please try again."
      end
    end
  end

  # displays the itinerary's details
  def print_details(itinerary)
    puts ""
    puts "#{itinerary.title}".blue.bold
    # refactor....fix formatting
    puts "#{itinerary.summary}".yellow
    puts ""
    itinerary.print_attractions
    puts "Click for more info: ".bold + "#{BalboaParkItineraryIdeas::Scraper::URL}#{itinerary.itinerary_url}".underline
    puts ""
  end

  # displays exit message to the user
  def goodbye
    puts ""
    puts "Goodbye! Hope to see you soon!".green.bold
    puts ""
  end
end
