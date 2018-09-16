require 'pry'

class WashingtonHikes::Hike
  attr_accessor :name, :length, :elevation_gain, :region, :description, :url, :rating
  @@all = []

  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_wta
    scraped_hikes = WashingtonHikes::Scraper.new.scrape_wta_hike_list
    scraped_hikes.each do |hike|
      attributes = {
        :name => hike.css(".item-header span").text.split(" - ")[0],
        :region => hike.css(".item-header h3.region").text.split(" -- ")[0],
        :length => hike.css(".hike-detail .hike-stats .hike-length span").children.text,
        :elevation_gain => hike.css(".hike-detail .hike-stats .hike-gain span").children.text,
        :rating => hike.css(".hike-detail .hike-stats .hike-rating .Rating .AverageRating .star-rating .current-rating").children.text,
        :url => hike.css(".item-header a.listitem-title").attribute("href").value
      }
      self.new(attributes) if attributes != {}
    end
  end

  def self.all
    @@all
  end
  
  # Lists hikes in a specified region
  def self.list_hikes(region)
    self.all.each.with_index(1) do |hike,i|
      puts "#{i}. #{hike.name} -- #{hike.length} -- #{hike.elevation_gain}"
    end
  end

  # Shows details on a chosen hike
   def hike_details(hike)
    puts "\n \n----------------------------"
    puts "\nWenatchee Guard Station"
    puts "Length: 5.8 Miles, one-way"
    puts "Elevation Gain: 1480 ft"
    puts "Rating: 5 stars"
    puts ""
    puts "Enjoy fantastic views of the Blue Mountains from this cozy retreat on the edge of the Umatilla National Forest. \n Perched on an overlook above the Blue Mountains and just outside the Wenaha-Tucannon Wilderness in the Umatilla National Forest, the Wenatchee Guard Station was built by the Civilian Conservation Corps in 1934-1935. While many such historic structures have since been lost, this one has been maintained as a year-round forest service rental. Summer visitors will be able to drive right to the cabin, and winter visitors can access the building by ski, snowshoe, or snowmobile."
    puts "\n----------------------------\n \n"

   # WashingtonHikes::CLI.what_next?("region")
  end

    # Lists regions the user can choose from
    def self.list_regions
      #ideally this would call a Hike class method that returns a list of all regions
      puts "1. North Cascades"
      puts "2. Northeast Washington"
      puts "3. Olympic Peninsula"
      puts "4. Seattle and Puget Sound"
      puts "5. Southeast Washington"
      puts "6. Southwest Washington"
    end
end