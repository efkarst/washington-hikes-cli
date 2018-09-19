# Command Line Interface for Washington Hikes CLI App
class WashingtonHikes::CLI
  attr_accessor :region, :hike_list_scope

  def start
    puts "\n\nWelcome to Washington Hikes!"
    puts "\n\nFinding the best hikes across Washington..."
    WashingtonHikes::Hike.create_from_wta
    welcome
  end

  def welcome
    puts "\n\nWhat would you like to do?"
    puts "1. Find top rated hikes in a specific region of Washington"
    puts "2. Browse top rated across all of Washington"
    puts "3. Exit the app.\n "
    puts "Type '1', '2', or '3' to choose."


    input = gets.chomp

    case input
    when "1"
      choose_region
    when "2"
      @hike_list_scope = "all"
      choose_hike
    when "3"
      exit
    else
      welcome
    end
  end

  def choose_region
    puts "\n\nHere are the regions you can choose from:\n "
    region_list = WashingtonHikes::Region.list_regions
    puts "\nChoose a region by typing the corresponding number, or type 'menu' to get to the main menu."

    input = gets.chomp

    if input == "menu"
      welcome
    elsif input.to_i.between?(1,region_list.size)
      @region = region_list[input.to_i]
      @hike_list_scope = "region"
      choose_hike
    else
      choose_region
    end
  end

  def choose_hike
    if @hike_list_scope == "all"
      puts "\n\nHere are the top rated hikes in Washington:\n "
      hike_list = WashingtonHikes::Hike.list_all_hikes
    elsif @hike_list_scope == "region"
      puts "\n\nHere are the top rated hikes in the #{@region}:\n "
      hike_list = @region.list_hikes_from_region
    end

    puts "\nChoose a hike by typing the corresponding number, or type 'menu' to get to the main menu."

    input = gets.chomp
    
    if input == "menu"
      welcome
    elsif input.to_i.between?(1,hike_list.size)
      hike = hike_list[input.to_i]
      hike.list_hike_details
      @region = hike.region
    else
      choose_hike
    end

    what_next?
  end

  def what_next?
    # do i need separate paths for users who choose to brose by region vs. brose all? probably
    puts "\n\nWhat would you like to do next?\n "
      puts "1. See more top rated hikes in this region."
      puts "2. See top rated hikes across Washington."
      puts "3. Choose a region."
      puts "4. Exit the app.\n "
      puts "Type '1', '2', '3' or '4' to choose."
  
      input = gets.chomp
  
      case input
      when "1"
        @hike_list_scope = "region"
        choose_hike
      when "2"
        @hike_list_scope = "all"
        choose_hike
      when "3"
        choose_region
      when "4"
        exit
      else
        what_next?
      end
  end

end
