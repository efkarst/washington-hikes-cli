require 'pry'

class WashingtonHikes::Hike
  attr_accessor :name, :length, :type, :elevation_gain, :region, :description, :url, :rating, :features
  @@all = []

  # Initialize a hike with a hash of attributes, and connect hike and region instances
  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  # Create new hike instances with attributes gathered from scraped WTA page
  def self.create_from_wta
    WashingtonHikes::Scraper.scrape_wta_hike_list.each do |hike| 
      hike[:region] = WashingtonHikes::Region.find_or_create_region_by_name(hike[:region])
      new_hike = self.new(hike)
      new_hike.region.add_hike(new_hike)
    end
  end

  # All hikes in class
  def self.all
    @@all
  end

  # Add additional properties to hikes users want to see details on
  def add_hike_details
    WashingtonHikes::Scraper.scrape_wta_hike_description(self.url).each {|key, value| self.send(("#{key}="), value)}
  end
end

