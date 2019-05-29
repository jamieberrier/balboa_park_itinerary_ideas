# The CLI Controller - responsible for business logic/user interactions
class BalboaParkItineraryIdeas::CLI

  def call
    @s = BalboaParkItineraryIdeas::Scraper.new
    @s.scrape_itineraries
    @welcome_header = @s.scrape_welcome_header
    @welcome_message = @s.scrape_welcome_message
    @header = @s.scrape_header

    start
  end

  def start
    welcome_message
    list_itineraries
    menu
  end

  # displays scraped welome header and message
  def welcome_message
    @border = "------------------------------------------------------------------------------"

    puts @border
    puts "#{@welcome_header}".blue.bold
    puts Strings.wrap(@welcome_message, 80)
    puts @border
  end

  # lists the itineraries for the user to choose from
  def list_itineraries
    puts "\n#{@header}".blue.bold

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
        @s.scrape_itinerary_page(itinerary)
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

  # displays the itinerary's details: title, summary, and each attraction's name, description, and URL (if has one)
  def print_details(itinerary)
    puts "\n#{itinerary.title}".blue.bold
    puts Strings.wrap(itinerary.summary, 86).yellow

    itinerary.attractions.each do |attraction|
      puts "\n#{attraction[:name]}".bold.red
      puts Strings.wrap(attraction[:description], 75)
      
      unless attraction[:attraction_url].nil?
        puts "Click for more info: ".green.bold + "#{attraction[:attraction_url]}".green.underline
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
