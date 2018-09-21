require 'pry'

class WashingtonHikes::Hike
  attr_accessor :name, :length, :elevation_gain, :region, :description, :url, :rating, :features
  @@all = []

  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_wta
    hikes = WashingtonHikes::Scraper.scrape_wta_hike_list
    hikes.each do |hike| 
      hike[:region] = WashingtonHikes::Region.find_or_create_region_by_name(hike[:region])
      new_hike = self.new(hike)
      new_hike.region.hikes << new_hike
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

   def list_hike_details
    add_hike_details
    puts "\n----------------------------"
    puts "\n#{self.name}"
    puts "Region: #{self.region.name}"
    puts "Length: #{self.length}"
    puts "Elevation Gain: #{self.elevation_gain}"
    puts "Rating: #{self.rating} / 5"
    puts "Features: #{self.features.join(", ")}"
    puts ""
    puts "#{self.description}"
    puts "\n----------------------------\n \n"
  end
end