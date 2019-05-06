# The CLI Controller - responsible for business logic/user interactions
class BalboaParkItineraryIdeas::CLI

  def call
    welcome_message
    list
    menu
  end

  def welcome_message
    puts "------------------------------------------------------------------------------"
    puts "Welcome to Balboa Park"
    puts ""
    puts "Ever changing. Always amazing. Where culture, science, and nature collide,"
    puts "Balboa Park is home to more than 16 museums, multiple performing arts venues,"
    puts "lovely gardens, trails, and many other creative and recreational attractions,"
    puts "including the San Diego Zoo. With a variety of cultural institutions among its"
    puts "1,200 beautiful and lushly planted acres, there is something for everyone."
    puts "------------------------------------------------------------------------------"
  end

  def list
    puts ""
    puts "Itinerary Ideas:"
    puts "1. Birds of Balboa Park"
    puts "2. Kids"
    puts "3. Nature Lover"
    puts "4. 60-90 Minute Tour"
    puts "5. Explorer"
    puts "6. Only in Balboa Park"
    puts "7. The Shopper"
    puts "8. Architecture"
    puts "9. Eccentric"
  end

  def menu
    input = nil
    while input != "exit"
      puts "-------------------------------------------------------------------"
      puts "What would you like to do? Your choices are:"
      puts ""
      puts "Type the itinerary number to see the details ('1', '2', '3'....'9')"
      puts "Type 'list' to see the list again"
      puts "Type 'exit'"
      puts "-------------------------------------------------------------------"

      input = gets.strip.downcase

      if input.to_i > 0 && input.to_i <= 9
        puts "Here are the details of itinerary ##{input}."
      elsif input == "list"
        list
      elsif input == "exit"
        goodbye
      else
        puts "Didn't understand, please try again."
      end


    end
  end

  def goodbye
    puts ""
    puts "Hope to see you soon!"
    puts ""
  end
end
