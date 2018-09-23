require 'pry'

class WashingtonHikes::Scraper
  def self.get_page(url)
    Nokogiri::HTML(open(url))
  end

  def self.scrape_wta_hike_list
    number_of_pages = 2
    hikes = []
    page_index = 0
    
    # Iterate through the number of hike pages you wish to scrape
    number_of_pages.times do 
      url = "https://www.wta.org/go-outside/hikes?b_start:int=#{page_index}"
      page_of_hikes =  get_page(url).css("div#search-result-listing .search-result-item")

      # Collect a hash of hike attributes for each hike on a page
      page_of_hikes.each do |hike|
        hike_attributes = {
          :name => hike.css(".item-header span").text.split(" - ")[0].strip,
          :region => WashingtonHikes::Region.find_or_create_region_by_name(hike.css(".item-header h3.region").text.split(" -- ")[0].strip),
          :length => hike.css(".hike-detail .hike-stats .hike-length").size == 0 ? "unknown" : hike.css(".hike-detail .hike-stats .hike-length span").children.text.split(",")[0].split(" ")[0].to_i,
          :type => hike.css(".hike-detail .hike-stats .hike-gain").size == 0 ? "unknown" : hike.css(".hike-detail .hike-stats .hike-gain span").children.text.strip.to_i,
          :elevation_gain => hike.css(".hike-detail .hike-stats .hike-length").size == 0 ? "unknown" : hike.css(".hike-detail .hike-stats .hike-length span").children.text.split(",")[-1].strip,
          :url => hike.css(".item-header a.listitem-title").attribute("href").value.strip
        }
        hikes << hike_attributes
      end      
      page_index += 30 #update url index -- wta always shows 30 hikes / page
    end
    hikes #return an array of hike hashes
  end

  def self.scrape_wta_hike_details(url)
    scraped_hike_details = get_page(url).css("#hike-wrapper")

    hike_details = {
      :features => scrape_wta_hike_features(scraped_hike_details),
      :description => scraped_hike_details.css("#hike-body-text p").size == 0 ? "" : scraped_hike_details.css("#hike-body-text p")[0].text,
      :rating => scraped_hike_details.css("#hike-top #hike-stats #hike-rating .Rating .AverageRating .star-rating .current-rating").text.split(" ")[0]
    }
  end

  def self.scrape_wta_hike_features(scraped_details)
    # Extract hike feature list
    feature_list = []
    scraped_feature_list = scraped_details.css("#hike-top #hike-features .feature")
    if scraped_feature_list != nil
      scraped_feature_list.each.with_index do |feature,i|
        puts scraped_feature_list.attribute("data-title").value
        feature_list << scraped_feature_list[i].attribute("data-title").value
      end
    end
    feature_list
  end

end