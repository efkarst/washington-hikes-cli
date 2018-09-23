class WashingtonHikes::Region
  attr_accessor :name, :hikes, :features
  @@all = []
  
  def initialize(name)
    @name = name
    @hikes = []
    @@all << self
  end

  def self.find_or_create_region_by_name(name)
    existing = self.all.detect{|region| region.name == name}
    existing != nil ? existing : self.new(name)
  end

  def self.all
    @@all
  end

  def add_hike(hike)
    @hikes << hike
  end
end