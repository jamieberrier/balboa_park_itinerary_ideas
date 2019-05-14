# The CLI Controller - responsible for business logic/user interactions
class BalboaParkItineraryIdeas::CLI

  def call
    make_itineraries
    add_attributes_to_itineraries
    welcome_message
    list
    menu
  end

  def make_itineraries
    itineraries_array = BalboaParkItineraryIdeas::Scraper.scrape_itineraries
    BalboaParkItineraryIdeas::Itinerary.create_from_collection(itineraries_array)
  end

  def add_attributes_to_itineraries
    BalboaParkItineraryIdeas::Itinerary.all.each do |itinerary|
      attributes = BalboaParkItineraryIdeas::Scraper.scrape_itinerary_page(BalboaParkItineraryIdeas::Scraper::URL + itinerary.itinerary_url)
      itinerary.add_itinerary_attributes(attributes)
    end
    binding.pry
  end

  # scrape from balboapark.org
  def welcome_message
    puts "------------------------------------------------------------------------------"
    puts "Welcome to Balboa Park".blue.bold
    puts "Ever changing. Always amazing."
    puts "Where culture, science, and nature collide,"
    puts "Balboa Park is home to more than 16 museums, multiple performing arts venues,"
    puts "lovely gardens, trails, and many other creative and recreational attractions,"
    puts "including the San Diego Zoo. With a variety of cultural institutions among its"
    puts "1,200 beautiful and lushly planted acres, there is something for everyone."
    puts "------------------------------------------------------------------------------"
  end

  def list
    puts ""
    puts "Itinerary Ideas:".blue.bold
    BalboaParkItineraryIdeas::Itinerary.all.each.with_index(1) do |itinerary, i|
      puts "#{i}.".green.bold + " #{itinerary.title}".bold
    end
  end

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
        list
      elsif input == "exit"
        goodbye
      else
        puts "Didn't understand, please try again."
      end
    end
  end

  def print_details(itinerary)
    puts ""
    puts "#{itinerary.title}".blue.bold
    puts ""
    # refactor....fix formatting
    #puts <<-DOC.gsub /^\s*/, ''
    #  #{itinerary.summary}
    #DOC
    puts "#{itinerary.summary}".yellow
    puts ""
    itinerary.print_attractions
    puts "Click for more info: ".bold + "#{BalboaParkItineraryIdeas::Scraper::URL}#{itinerary.itinerary_url}".underline
    puts ""
  end

  def goodbye
    puts ""
    puts "Goodbye! Hope to see you soon!".green.bold
    puts ""
  end
end
