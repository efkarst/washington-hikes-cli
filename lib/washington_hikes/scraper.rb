require 'pry'

class WashingtonHikes::Scraper
  def self.get_wta_page(url)
    #working
    #Nokogiri::HTML(open("https://www.wta.org/go-outside/hikes?b_start:int=0"))

    Nokogiri::HTML(open(url))
  end

  def self.scrape_wta_hike_list
    #working code for 1st page
    #get_wta_page.css("div#search-result-listing .search-result-item")
    
    pages = []
    i = 0
    2.times do
      url = "https://www.wta.org/go-outside/hikes?b_start:int=#{i}"
      pages << get_wta_page(url).css("div#search-result-listing .search-result-item")
      i += 30
    end
    pages
    
  end

  def self.get_wta_detail_page(url)
    Nokogiri::HTML(open(url))
  end
  
  def self.scrape_wta_hike_details(url)
    # Scrape details
    details = get_wta_detail_page(url).css("#hike-wrapper")
    
    # Extract list of features
    feature_list = []
    puts url
    scraped_feature_list = details.css("#hike-top #hike-features .feature")
    if scraped_feature_list != nil
      scraped_feature_list.each.with_index do |feature,i|
        puts scraped_feature_list.attribute("data-title").value
        feature_list << scraped_feature_list[i].attribute("data-title").value
      end
    end

    # Extract description
    if details.css("#hike-body-text p") != []
      description_value = details.css("#hike-body-text p")[0].text
    end

    # Return features and description
    {:features => feature_list, :description => description_value}
  end
end