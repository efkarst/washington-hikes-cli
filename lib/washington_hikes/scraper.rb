require 'pry'

class WashingtonHikes::Scraper
  def self.get_wta_page
    Nokogiri::HTML(open("https://www.wta.org/go-outside/hikes?b_start:int=0"))
  end

  def self.scrape_wta_hike_list
    #how do i iterate through more hikes???
    #pages = []
    #2.times do
      #pages << get_wta_page.css("div#search-result-listing .search-result-item")
    #end

    #working code for 1st page
    get_wta_page.css("div#search-result-listing .search-result-item")
  end

  def self.get_wta_detail_page(url)
    Nokogiri::HTML(open(url))
  end
  
  def self.scrape_wta_hike_details(url)
    # Scrape details
    details = get_wta_detail_page(url).css("#hike-wrapper")
    #binding.pry
    # Extract list of features
    #feature_list = []
    #scraped_feature_list = details.css("#hike-top #hike-features .feature")[0]#.css("div")
    ##binding.pry
    #if scraped_feature_list != nil
    #  scraped_feature_list.each.with_index do |feature,i|
    #    feature_list << scraped_feature_list.css("div")[i].attribute("data-title").value
    #  end
    #end

    # Extract description
    #binding.pry
    description_value = []
    #binding.pry
    if details.css("#hike-body-text p") != []
      description_value = details.css("#hike-body-text p")[0].text
    end
    #{:features => feature_list, :description => description_value}
    {:description => description_value}
  end
end