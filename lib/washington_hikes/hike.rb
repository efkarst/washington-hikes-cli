require 'pry'

class WashingtonHikes::Hike
  attr_accessor :name, :length, :type, :elevation_gain, :region, :description, :url, :rating, :features
  @@all = []

  # Initialize a hike with a hash of attributes, and connect hike and region instances
  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @region.add_hike(self)
    @@all << self
  end

  # Create new hike instances with attributes gathered from scraped WTA page
  def self.create_from_wta
    hikes = WashingtonHikes::Scraper.scrape_wta_hike_list
    #binding.pry
   #ikes[:region] = WashingtonHikes::Region.find_or_create_region_by_name(hikes[:region])
    hikes.each do |hike| 
      hike[:region] = WashingtonHikes::Region.find_or_create_region_by_name(hike[:region])
      self.new(hike)
    end
  end

  # All hikes in class
  def self.all
    @@all
  end

  # Add additional properties to hikes users want to see details on
  def add_hike_details
    scraped_details = WashingtonHikes::Scraper.scrape_wta_hike_description(self.url)
    scraped_details.each {|key, value| self.send(("#{key}="), value)}
  end
end