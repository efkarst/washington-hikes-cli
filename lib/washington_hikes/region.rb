class WashingtonHikes::Region
  attr_accessor :name, :hikes, :features
  @@all = []
  
  def initialize(name)
    @name = name
    @hikes = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.list_regions
    region_by_displayed_number = {}
    self.all.each.with_index(1) do |region,i| 
      puts "#{i}. #{region.name}"
      region_by_displayed_number[i] = region
    end
    region_by_displayed_number
  end

  def self.find_or_create_region_by_name(name)
    existing = self.all.detect{|region| region.name == name}
    existing != nil ? existing : self.new(name)
  end

  def list_hikes_from_region
    hike_by_displayed_number = {}
    self.hikes.each.with_index(1) do |hike,i|
      puts "#{i}. #{hike.name} -- #{hike.length} -- #{hike.elevation_gain}"
      hike_by_displayed_number[i] = hike
    end
    hike_by_displayed_number
  end
end