class WashingtonHikes::Region
  attr_accessor :name, :hikes
  @@all = []
  
  # Initializes a region with a name and hikes array
  def initialize(name)
    @name = name
    @hikes = []
    @@all << self
  end

  # Find or create a new region by name
  def self.find_or_create_region_by_name(name)
    existing = self.all.detect{|region| region.name == name}
    existing != nil ? existing : self.new(name)
  end

  # All regions in class
  def self.all
    @@all
  end

  # Add hike to region's 'hikes' array
  def add_hike(hike)
    @hikes << hike
  end

  # Identifies the most common landcape features in a region based on hike features
  def common_landscape_features
    # Collect count of each landscape feature from hikes in region
    feature_list = {}
    not_landscape = ["Dogs allowed on leash", "Dogs not allowed", "Established campsites", "Good for kids", "Fall foliage"]

    @hikes.each do |hike|
      hike.features.each do |feature|
        if not_landscape.include?(feature) == false
          feature_list[feature] == nil ? feature_list[feature] = 1 : feature_list[feature] += 1
        end
      end
    end

    # Sort feature list by most common and return the top 5 landscape features
    feature_list.sort_by{|feature,count| count}.reverse.flatten.delete_if{|x| x.is_a?(Integer)}[0..4]
  end

  # Calculates the average rating of popular hikes in the region
  def average_hike_rating
    ratings = @hikes.collect {|hike| hike.rating}   # Collect ratings of hikes in region
    (ratings.sum / ratings.size).round(2)           # Return the average rating of hikes in region
  end
end