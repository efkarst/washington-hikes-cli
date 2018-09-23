# Command Line Interface for Washington Hikes CLI App
class WashingtonHikes::CLI
  attr_accessor :region, :filters

  def start
    puts "\n\nWelcome to Washington Hikes!"
    puts "\n\nFinding the most popular hikes across Washington..."
    WashingtonHikes::Hike.create_from_wta
    @filters = {}
    welcome
  end

  def welcome
    puts "\n\nWhat would you like to do?"
    puts "1. Find the most popular hikes in a specific region of Washington"
    puts "2. Browse the most popular hikes across all of Washington"
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

  def choose_region
    puts "\n\nHere are the regions you can choose from:\n "
    regions = WashingtonHikes::Region.all

    list_regions(regions)

    puts "\nChoose a region by typing the corresponding number, or type 'menu' to get to the main menu."
    input = gets.chomp

    if input == "menu"
      welcome
    elsif input.to_i.between?(1, regions.size)
      @region = regions[input.to_i - 1]
      @filters["region"] = @region.name
      choose_hike
    else
      choose_region
    end
  end

  def list_regions(regions)
    regions.each.with_index(1) {|region,i| puts "#{i}. #{region.name}"}
  end

  def choose_hike
    if @filters.keys.include?("region")
      puts "\n\nHere are the most popular hikes in the #{@region.name}:\n "
      hikes = @region.hikes
    else
      puts "\n\nHere are the most popular hikes in Washington:\n "
      hikes = WashingtonHikes::Hike.all
    end

    #@filters == [] ? hikes = WashingtonHikes::Hike.all : hikes = WashingtonHikes::Hike.filtered_hike_list(@filters)

    list_hikes(hikes)

    puts "\nChoose a hike by typing the corresponding number, or type 'menu' to get to the main menu."
    input = gets.chomp

    if input == "menu"
      welcome
    elsif input.to_i.between?(1, hikes.size)
      list_hike_details(hikes[input.to_i - 1])
      @region = hikes[input.to_i - 1].region
    else
      choose_hike
    end

    what_next?
  end

  def list_hikes(hikes)
    hikes.each.with_index(1) {|hike,i| puts "#{i}. #{hike.name} -- #{hike.length} miles, #{hike.type} -- #{hike.elevation_gain}"}
  end

  def list_hike_details(hike)
    hike.add_hike_details
    puts "\n----------------------------"
    puts "\n#{hike.name}"
    puts "Region: #{hike.region.name}"
    puts "Length: #{hike.length} miles, #{hike.type}"
    puts "Elevation Gain: #{hike.elevation_gain}"
    puts "Rating: #{hike.rating} / 5"
    puts "Features: #{hike.features.join(", ")}"
    puts ""
    puts "#{hike.description}"
    puts "\n----------------------------\n \n"
  end

  def what_next?
    # do i need separate paths for users who choose to brose by region vs. brose all? probably
    puts "\n\nWhat would you like to do next?\n "
      puts "1. See more popular hikes in this region."
      puts "2. See popular hikes across Washington."
      puts "3. Choose a different region."
      puts "4. Exit the app.\n "
      puts "Type '1', '2', '3' or '4' to choose."
  
      input = gets.chomp
  
      case input
      when "1"
        #@hike_list_scope = "region"
        @filters["region"] = @region.name
        choose_hike
      when "2"
        #@hike_list_scope = "all"
        @filters.delete("region")
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
