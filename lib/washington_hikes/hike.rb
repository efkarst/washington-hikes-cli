require 'pry'

class WashingtonHikes::Hike
  attr_accessor :name, :length, :type, :elevation_gain, :region, :description, :url, :rating, :features
  @@all = []

  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @region.add_hike(self)
    @@all << self
  end

  def self.create_from_wta
    hikes = WashingtonHikes::Scraper.scrape_wta_hike_list
    hikes.each {|hike| self.new(hike)}
  end

  def self.all
    @@all
  end

  def add_hike_details
    scraped_details = WashingtonHikes::Scraper.scrape_wta_hike_description(self.url)
    scraped_details.each {|key, value| self.send(("#{key}="), value)}
  end
end