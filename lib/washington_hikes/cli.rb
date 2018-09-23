class WashingtonHikes::CLI
  attr_accessor :region
  
  def start
    puts "\n\nWelcome to Washington Hikes!".green
    puts "\n\nFinding the most popular hikes across Washington..."
    WashingtonHikes::Hike.create_from_wta
    @region = "all"
    welcome
  end



  # Determine if the user wants to find hikes in a region or browse hikes across Washington
  def welcome
    puts "\n\nWhat would you like to do?".green
    puts "1. Find the most popular hikes in a specific region of Washington"
    puts "2. Browse the most popular hikes across Washington"
    puts "3. Exit the app.\n "
    puts "Type '1', '2', or '3' to choose."

    input = gets.chomp

    case input
    when "1"
      choose_region
    when "2"
      choose_hike
    when "3"
      exit
    else
      welcome
    end
  end



  # Prompts user to choose a region from a list of regions
  def choose_region
    puts "\n\nHere are the regions you can choose from:\n "
    regions = WashingtonHikes::Region.all # Get list of regions
    list_regions(regions)                 # Display list of regions

    puts "\nChoose a region by typing the corresponding number, or type 'menu' to go to the main menu."
    input = gets.chomp

    if input == "menu"                            # Returns user to main menu
      welcome
    elsif input.to_i.between?(1, regions.size)    # ID user-selected region and lets them choose a hike
      @region = regions[input.to_i - 1]
      choose_hike
    else                                          # If input isn't recognized, have user choose a region again
      choose_region
    end
  end



  # Lists regions 
  def list_regions(regions)
    regions.each.with_index(1) do |region,i| 
      puts "#{i}. #{region.name}".green
      puts "   Landscape: #{region.common_landscape_features.join(", ")}".gray
      puts "   Average Hike Rating: #{region.average_hike_rating}\n ".gray
    end
  end



  # Prompts users to choose a hike from a list of hikes
  def choose_hike
    # Gather list of hikes - either all hikes, or hikes in a specific region
    if @region == "all"
      puts "\n\nHere are the most popular hikes in Washington:\n ".bold
      hikes = WashingtonHikes::Hike.all
    else
      puts "\n\nHere are the most popular hikes in the #{@region.name}:\n ".bold
      hikes = @region.hikes
    end

    # Lists hikes in designated region
    list_hikes(hikes)

    puts "\nChoose a hike by typing the corresponding number, or type 'menu' to go to the main menu."
    input = gets.chomp

    if input == "menu"                            # Returns user to main menu
      welcome
    elsif input.to_i.between?(1, hikes.size)      # ID user-selected hike and show them hike details
      list_hike_details(hikes[input.to_i - 1])
      @region = hikes[input.to_i - 1].region
    else                                          # If input isn't recognized, have user choose hike again
      choose_hike
    end

    what_next?  # Prompt user to take another action after seeing hike details
  end



  # Lists hikes in selected region
  def list_hikes(hikes)
    hikes.each.with_index(1) {|hike,i| puts "#{i}. #{hike.name.green} -- #{hike.length} miles, #{hike.type} -- #{hike.elevation_gain}"}
  end



  # Lists details for selected hike
  def list_hike_details(hike)
    hike.add_hike_details
    puts "\n\n----------------------------"
    puts "\n#{hike.name}".green
    puts "Region: #{hike.region.name}"
    puts "Length: #{hike.length} miles, #{hike.type}"
    puts "Elevation Gain: #{hike.elevation_gain}"
    puts "Rating: #{hike.rating} / 5"
    puts "Features: #{hike.features.join(", ")}"
    puts ""
    puts "#{hike.description}"
    puts "\n----------------------------\n \n"
  end



  # Prompts user to take another action after seeing hike details
  def what_next?
    puts "\n\nWhat would you like to do next?\n "
    puts "1. See more popular hikes in this region."
    puts "2. See popular hikes across Washington."
    puts "3. Choose a different region."
    puts "4. Exit the app.\n "
    puts "Type '1', '2', '3' or '4' to choose."

    input = gets.chomp
  
    case input
    when "1"
      choose_hike      # User can choose a hike from the region the current hike is in
    when "2"
      @region = "all"  # User can choose a hike from all hikes
      choose_hike
    when "3"
      choose_region    # User can choose a new region to brose
    when "4"
      exit             # Exit the app
    else
      what_next?       # If input isn't recognized, prompt user again
    end
  end
end