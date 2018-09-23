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

  def top_landscape_features
    feature_list = {}
    @hikes.each do |hike|
      hike.features.each do |feature|
        feature_list[feature] == nil ? feature_list[feature] = 1 : feature_list[feature] += 1
      end
    end
    
    common_features = []
    not_landscape = ["Dogs allowed on leash", "Dogs not allowed", "Established campsites", "Good for kids", "Fall foliage"]
    feature_list.sort_by{|feature,count| count}.reverse.each do |feature| 
      common_features << feature[0] if not_landscape.include?(feature[0]) == false
    end
    common_features[0..4]
  end

  def average_hike_rating
    ratings = @hikes.collect {|hike| hike.rating}
    (ratings.sum / ratings.size).round(2)
  end
end