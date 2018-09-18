class WashingtonHikes::Region
  attr_accessor :name, :hikes, :features
  @@all = []
  
  def initialize(name)
    @name = name
    @@all << self
  end

  def self.all
    @@all
  end

  def self.list_regions
    puts ""
    self.all.each.with_index(1) {|region,i| puts "#{i}. #{region.name}"}
  end

  def self.find_or_create_region_by_name(name)
    existing = self.all.detect{|region| region.name == name}
    existing != nil ? existing : self.new(name)
  end

  def hikes
  end
end