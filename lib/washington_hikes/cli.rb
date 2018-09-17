# Command Line Interface for Washington Hikes CLI App
class WashingtonHikes::CLI
  def start
    WashingtonHikes::Hike.create_from_wta
    #create some hike instances, eventaully through scrapting
    #@hike_1 = WashingtonHikes::Hike.new({:url => "wta.org"})
    #hike_2 = WashingtonHikes::Hike.new({})

    puts "\nWelcome to Washington Hikes!\n "

    puts "What would you like to do? Type '1', '2', or '3'."
    puts "1. Find a hike in a specific region of Washington"
    puts "2. Browse all hikes in Washington"
    puts "3. Exit the app.\n "

    input = gets.chomp

    case input
    when "1"
      # Show regions
      choose_region
    when "2"
      # Show top 30 hikes hikes
      choose_hike("all")
    when "3"
      # exit the app
      exit
    end
  end

  # Prompts user to choose a region to see hikes in
  def choose_region
    puts "Choose a region by typing the corresponding number, or type 'back' to go back to the main menu."
    WashingtonHikes::Hike.list_regions

    input = gets.chomp

    case input
    when "1"
      choose_hike("region_1")
    when "2"
      choose_hike("region_2")
    when "3"
      choose_hike("region_3")
    when "4"
      choose_hike("region_4")
    when "5"
      choose_hike("region_5")
    when "6"
      choose_hike("region_6")
    when "back"
      start
    end
  end

  # Prompts user to choose a hike
  def choose_hike(region)
    puts "Here are hikes in the region:\n "
    WashingtonHikes::Hike.list_hikes(region)

    puts "Choose a number to see details on a hike, or type 'back' to get to the main menu."
    input = gets.chomp

    #ID which hike instance corresponds to the hike the user selected
  
    # Get detailson the delected hike
    case input
    when "back"
      start
    else
      WashingtonHikes::Hike.all.sample.list_hike_details
    end

    what_next?(region)
  end

  def what_next?(region)
    puts "What would you like to do next? Type '1', '2', or '3'."
      puts "1. See more hikes in this region."
      puts "2. Start over."
      puts "3. Exit the app.\n "
  
      input = gets.chomp
  
      case input
      when "1"
        choose_hike("region")
      when "2"
        start
      when "3"
        exit
      end
  end

end
