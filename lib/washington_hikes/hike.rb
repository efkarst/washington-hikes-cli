require 'pry'

class WashingtonHikes::Hike
  attr_accessor :name, :length, :elevation_gain, :region, :description, :url, :rating, :features
  @@all = []

  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_wta
    # working code
    #scraped_hikes = WashingtonHikes::Scraper.scrape_wta_hike_list
    #scraped_hikes.each do |hike|
    #  attributes = {
    #    :name => hike.css(".item-header span").text.split(" - ")[0].strip,
    #    :region => WashingtonHikes::Region.find_or_create_region_by_name(hike.css(".item-header h3.region").text.split(" -- ")[0].strip),
    #    :length => hike.css(".hike-detail .hike-stats .hike-length span").children.text.strip,
    #    :elevation_gain => hike.css(".hike-detail .hike-stats .hike-gain span").children.text.strip,
    #    :rating => hike.css(".hike-detail .hike-stats .hike-rating .Rating .AverageRating .star-rating .current-rating").children.text.strip,
    #    :url => hike.css(".item-header a.listitem-title").attribute("href").value.strip
    #  }
    #  self.new(attributes)
    #end

    scraped_hikes = WashingtonHikes::Scraper.scrape_wta_hike_list
    scraped_hikes.each do |page_of_hikes|
      page_of_hikes.each do |hike|
        region_of_hike = WashingtonHikes::Region.find_or_create_region_by_name(hike.css(".item-header h3.region").text.split(" -- ")[0].strip)
        attributes = {
          :name => hike.css(".item-header span").text.split(" - ")[0].strip,
          :region => region_of_hike,
          :length => hike.css(".hike-detail .hike-stats .hike-length span").children.text.strip,
          :elevation_gain => hike.css(".hike-detail .hike-stats .hike-gain span").children.text.strip,
          :rating => hike.css(".hike-detail .hike-stats .hike-rating .Rating .AverageRating .star-rating .current-rating").children.text.strip,
          :url => hike.css(".item-header a.listitem-title").attribute("href").value.strip
        }
        new_hike = self.new(attributes)
        region_of_hike.hikes << new_hike
      end
    end
  end

  def self.all
    @@all
  end

  def self.list_all_hikes
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
    puts "Region: #{self.region.name}"
    puts "Length: #{self.length}"
    puts "Elevation Gain: #{self.elevation_gain}"
    puts "Rating: #{self.rating} / 5"
   # puts "Features: #{self.features.join(", ")}"
    puts ""
    puts "#{self.description}"
    puts "\n----------------------------\n \n"
  end
end