# Command Line Interface for Washington Hikes CLI App
class WashingtonHikes::CLI
  attr_accessor :region

  def start
    #Scrape WTA to create hike and region object instances
    # need to figure out how to grab more hike instances by looping through web pages...
    WashingtonHikes::Hike.create_from_wta
    #binding.pry
    welcome
  end

  def welcome
    puts "\nWelcome to Washington Hikes!\n "
    puts ""
    puts "What would you like to do? Type '1', '2', or '3'."
    puts "1. Find hikes in a specific region of Washington"
    puts "2. Browse hikes across all of Washington"
    puts "3. Exit the app.\n "

    input = gets.chomp

    case input
    when "1"
      choose_region
    when "2"
      choose_hike_from_all
    when "3"
      exit
    else
      welcome
    end
  end

  
  # Prompts user to choose a region to see hikes in
  def choose_region
    puts "Here are the regions you can choose from:\n "
    regions = WashingtonHikes::Region.list_regions
    puts "Choose a region by typing the corresponding number, or type 'menu' to get to the main menu."

    input = gets.chomp

    if input == "back"
      welcome
    else
      @region = regions[input.to_i]
      choose_hike_from_region
    end
  end

  # Prompts user to choose a hike
  def choose_hike_from_region
    puts "Here are hikes in the #{@region.name}:\n "
    hikes = @region.list_hikes_from_region
    puts "Choose a hike by typing the corresponding number, or type 'menu' to get to the main menu."

    input = gets.chomp
    
    if input == "back"
      welcome
    else
      hike = hikes[input.to_i]
      hike.list_hike_details
    end

    what_next?
  end

    # Prompts user to choose a hike
    def choose_hike_from_all
      puts "Here are hikes across Washington: "
      hikes = WashingtonHikes::Hike.list_all_hikes
      puts "Choose a hike by typing the corresponding number, or type 'menu' to get to the main menu."
  
      input = gets.chomp
      
      if input == "back"
        welcome
      else
        hike = hikes[input.to_i]
        hike.list_hike_details
        @region = hike.region
      end
  
      what_next?
    end

  def what_next?
    # do i need separate paths for users who choose to brose by region vs. brose all? probably
    puts "What would you like to do next? Type '1', '2', or '3'."
      puts "1. See more hikes in this region."
      puts "2. See all hikes."
      puts "3. See regions"
      puts "4. Exit the app.\n "
  
      input = gets.chomp
  
      case input
      when "1"
        choose_hike_from_region
      when "2"
        choose_hike_from_all
      when "3"
        choose_region
      when "4"
        exit
      else
        what_next?
      end
  end

end
