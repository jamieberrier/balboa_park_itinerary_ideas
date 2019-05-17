# The CLI Controller - responsible for business logic/user interactions
class BalboaParkItineraryIdeas::CLI

  def call
    make_itineraries
    #remove to call in menu
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
    #pass just itinerary_url and add URL in scraper
    BalboaParkItineraryIdeas::Itinerary.all.each do |itinerary|
      attributes = BalboaParkItineraryIdeas::Scraper.scrape_itinerary_page(BalboaParkItineraryIdeas::Scraper::URL + itinerary.itinerary_url)
      itinerary.add_itinerary_attributes(attributes)
    end
  end

  # display welome message scrape from balboapark.org
  def welcome_message
    puts "------------------------------------------------------------------------------"
    puts "#{BalboaParkItineraryIdeas::Scraper.scrape_welcome_header}".blue.bold
    puts Strings.wrap(BalboaParkItineraryIdeas::Scraper.scrape_welcome_message, 80)
    puts "------------------------------------------------------------------------------"
  end

  # lists the itineraries for the user to choose from
  def list_itineraries
    puts "\n#{BalboaParkItineraryIdeas::Scraper.scrape_header}".blue.bold
    BalboaParkItineraryIdeas::Itinerary.all.each.with_index(1) do |itinerary, i|
      puts "#{i}.".red.bold + " #{itinerary.title}".bold
    end
  end

  # displays the user's choices, gets the user's input, and either displays details of an itinerary, the list of itineraries, or exits
  def menu
    input = nil
    while input != "exit"
      puts "-------------------------------------------------------------------"
      puts "What would you like to do? Your choices are:".green.bold
      puts "Type the itinerary number " + "('1', '2', '3'....'9')".red.bold + " to see the details"
      puts "Type " + "list".red.bold + " to see the list again"
      puts "Type " + "exit".red.bold
      puts "-------------------------------------------------------------------"

      input = gets.strip.downcase

      if input.to_i > 0 && input.to_i <= 9 # use between or range/include?
        itinerary = BalboaParkItineraryIdeas::Itinerary.find(input.to_i)
        #add attributes for selected itinerary
        print_details(itinerary)
        #print_attractions(itinerary)
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
    puts "\n#{itinerary.title}".blue.bold
    puts Strings.wrap(itinerary.summary, 86).yellow
    puts ""
    
    itinerary.attractions.each do |x|
      puts "#{x[:name]}".bold.red
      puts Strings.wrap(x[:description], 75)
      if x[:attraction_url] != ""
        puts "Click for more info: ".green + "#{x[:attraction_url]}\n".green.underline
      end
    end

    puts "Click for more info about the #{itinerary.title} Itinerary: ".green.bold
    puts "#{BalboaParkItineraryIdeas::Scraper::URL}#{itinerary.itinerary_url}\n".green.underline
  end

  # displays exit message to the user
  def goodbye
    puts ""
    puts "Goodbye! Hope to see you soon!".green.bold
    puts ""
  end
end
