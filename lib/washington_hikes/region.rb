class WashingtonHikes::Region
  attr_accessor :name, :hikes
  @@all = []
  
  def initialize(name)
    @name = name
    @hikes = []
    @features = []
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

  def features
    feature_list = []
   # binding.pry
    @hikes.each do |hike|
      feature_list << hike.features
   # binding.pry
    #  hike.features.each do |feature|
     #   feature_list << feature if feature_list.include?(feature) == false
      #end
    end
    feature_list.flatten.uniq
    #binding.pry
    #Eif hike.features != nil
     # hike.features.each do |feature|
     #   @features << feature if @features.detect{|feat| feat == feature}
      #end
    #end
    #binding.pry
  end
end