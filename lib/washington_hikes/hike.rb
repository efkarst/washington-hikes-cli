require 'pry'

class WashingtonHikes::Hike
  attr_accessor :name, :length, :elevation_gain, :region, :description, :url, :rating, :features
  @@all = []

  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_wta
    scraped_hikes = WashingtonHikes::Scraper.scrape_wta_hike_list
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
    hike_by_displayed_number = {}
    self.all.each.with_index(1) do |hike,i|
      puts "#{i}. #{hike.name} -- #{hike.length} -- #{hike.elevation_gain}"
      hike_by_displayed_number[i] = hike
    end
    hike_by_displayed_number
  end

  def add_hike_details
    scraped_details = WashingtonHikes::Scraper.scrape_wta_hike_details(self.url)
    scraped_details.each {|key, value| self.send(("#{key}="), value)}
  end

  # Shows details on a chosen hike
   def list_hike_details
    add_hike_details
    puts "\n \n----------------------------"
    puts "\n#{self.name}"
    puts "Length: #{self.length}"
    puts "Elevation Gain: #{self.elevation_gain}"
    puts "Rating: #{self.rating} / 5"
   # puts "Features: #{self.features.join(", ")}"
    puts ""
    puts "#{self.description}"
    puts "\n----------------------------\n \n"
  end

  # Lists regions the user can choose from
  def self.list_regions
    regions = self.all.collect {|hike| hike.region}.uniq
    #regions.delete(nil)
    regions.each.with_index(1) {|region,i| puts "#{i}. #{region}"}
  end
end