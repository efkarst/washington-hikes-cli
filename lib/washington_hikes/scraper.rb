require 'pry'

class WashingtonHikes::Scraper
  def get_wta_page
    Nokogiri::HTML(open("https://www.wta.org/go-outside/hikes?b_start:int=0"))
  end

  def scrape_wta_hike_list
    get_wta_page.css("div#search-result-listing .search-result-item")
  end
end