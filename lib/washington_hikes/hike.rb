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
        :name => hike.css(".item-header span").text.split(" - ")[0].strip,
        :region => hike.css(".item-header h3.region").text.split(" -- ")[0].strip,
        :length => hike.css(".hike-detail .hike-stats .hike-length span").children.text.strip,
        :elevation_gain => hike.css(".hike-detail .hike-stats .hike-gain span").children.text.strip,
        :rating => hike.css(".hike-detail .hike-stats .hike-rating .Rating .AverageRating .star-rating .current-rating").children.text.strip,
        :url => hike.css(".item-header a.listitem-title").attribute("href").value.strip
      }
      self.new(attributes)
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
  end

  # Lists regions the user can choose from
  def self.list_regions
    regions = self.all.collect {|hike| hike.region}.uniq
    regions.delete(nil)
    regions.each.with_index(1) {|region,i| puts "#{i}. #{region}"}
  end
end