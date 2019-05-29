# The CLI Controller - responsible for business logic/user interactions
class BalboaParkItineraryIdeas::CLI

  def call
    BalboaParkItineraryIdeas::Scraper.new.scrape_itineraries
    welcome_message
    list_itineraries
    menu
  end

  # displays welome message scrape from balboapark.org
  def welcome_message
    @border = "------------------------------------------------------------------------------"
    puts @border
    puts "#{BalboaParkItineraryIdeas::Scraper.scrape_welcome_header}".blue.bold
    puts Strings.wrap(BalboaParkItineraryIdeas::Scraper.scrape_welcome_message, 80)
    puts @border
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
      puts @border
      puts "What would you like to do? Your choices are:".green.bold
      puts "Type the itinerary number " + "('1', '2', '3'....'9')".red.bold + " to see the details"
      puts "Type " + "list".red.bold + " to see the list again"
      puts "Type " + "exit".red.bold
      puts @border

      input = gets.strip.downcase

      if input.to_i.between?(1,9)
        itinerary = BalboaParkItineraryIdeas::Itinerary.find(input.to_i)
        add_attributes(itinerary)
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

  # scrapes and adds the itinerary's attributes from the individual itinerary's page
  def add_attributes(itinerary)
    attributes = BalboaParkItineraryIdeas::Scraper.scrape_itinerary_page(itinerary.url)
    itinerary.add_itinerary_attributes(attributes)
  end

  # displays the itinerary's details: title, summary along with each attraction's name, description, and URL (if has one)
  def print_details(itinerary)
    puts "\n#{itinerary.title}".blue.bold
    puts Strings.wrap(itinerary.summary, 86).yellow

    itinerary.attractions.each do |x|
      puts "\n#{x[:name]}".bold.red
      puts Strings.wrap(x[:description], 75)
      unless x[:attraction_url] == ""
        puts "Click for more info: ".green.bold + "#{x[:attraction_url]}".green.underline
      end
    end

    puts "\nClick below for more information about the ".red + "#{itinerary.title} Itinerary:".red.bold
    puts "#{itinerary.url}\n".green.underline
  end

  # displays exit message to the user
  def goodbye
    puts "\nGoodbye! Comeback soon!\n".green.bold
  end
end
