require 'pry'

class WashingtonHikes::Scraper
  def self.get_page(url)
    Nokogiri::HTML(open(url))
  end

  def self.scrape_wta_hike_list
    # Grab the first n pages of hikes
    number_of_pages = 2
    hikes = []
    page_index = 0
    number_of_pages.times do 
      url = "https://www.wta.org/go-outside/hikes?b_start:int=#{page_index}"
      page_of_hikes =  get_page(url).css("div#search-result-listing .search-result-item")
      page_of_hikes.each do |hike|
        hike_attributes = {
          :name => hike.css(".item-header span").text.split(" - ")[0].strip,
          :region => hike.css(".item-header h3.region").text.split(" -- ")[0].strip,
          :length => hike.css(".hike-detail .hike-stats .hike-length span").children.text.strip,
          :elevation_gain => hike.css(".hike-detail .hike-stats .hike-gain span").children.text.strip,
          :rating => hike.css(".hike-detail .hike-stats .hike-rating .Rating .AverageRating .star-rating .current-rating").children.text.strip,
          :url => hike.css(".item-header a.listitem-title").attribute("href").value.strip
        }
        hikes << hike_attributes
      end      
      page_index += 30
    end
    hikes
  end

  def self.scrape_wta_hike_details(url)
    # Scrape details
    scraped_details = get_page(url).css("#hike-wrapper")
    feature_list = scrape_wta_hike_features(scraped_details)
    description_text = scrape_wta_hike_description(scraped_details)

    # Return features and description
    {:features => feature_list, :description => description_text}
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

  def self.scrape_wta_hike_description(scraped_details)
    # Extract hike description
    description_text = ""
    scraped_description = scraped_details.css("#hike-body-text p")
    description_text = scraped_description[0].text if scraped_description != []
    description_text
  end
end