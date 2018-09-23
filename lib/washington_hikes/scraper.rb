require 'pry'

class WashingtonHikes::Scraper
  def self.get_page(url)
    Nokogiri::HTML(open(url))
  end

  def self.scrape_wta_hike_list
    number_of_pages = 2   # Number of WTA pages to scrape (they always show 30 hikes / page)
    hikes = []            # Create an empty erray to shovel hikes into
    page_index = 0      # 1st hike in WTA list that will be scaped - feeds into URL

    # Iterate through the number of hike pages you wish to scrape
    number_of_pages.times do 
      url = "https://www.wta.org/go-outside/hikes?b_start:int=#{page_index}"
      page_of_hikes =  get_page(url).css("div#search-result-listing .search-result-item")

      # Collect a hash of hike attributes for each hike on a page
      page_of_hikes.each do |hike|
        hike_attributes = {
          name:   hike.css(".item-header span").text.split(" - ")[0].strip,
          region: WashingtonHikes::Region.find_or_create_region_by_name(hike.css(".item-header h3.region").text.split(" -- ")[0].strip),
          url:    hike.css(".item-header a.listitem-title").attribute("href").value.strip,
          length: hike.css(".hike-detail .hike-stats .hike-length").size == 0 ? "unknown" : hike.css(".hike-detail .hike-stats .hike-length span").children.text.split(",")[0].split(" ")[0].to_i,
          type:   hike.css(".hike-detail .hike-stats .hike-length").size == 0 ? "unknown" : hike.css(".hike-detail .hike-stats .hike-length span").children.text.split(",")[-1].strip,
          rating: hike.css(".hike-detail .hike-stats .hike-rating .Rating .AverageRating .star-rating .current-rating").text.split(" ")[0].to_f,
          features: hike.css(".hike-detail .hike-stats .trip-features").size == 0 ? [] : hike.css(".hike-detail .hike-stats .trip-features")[0].children.css("img").collect{|feature| feature.attribute("title").value},
          elevation_gain: hike.css(".hike-detail .hike-stats .hike-gain").size == 0 ? "unknown" : hike.css(".hike-detail .hike-stats .hike-gain span").children.text.strip.to_i
        }
        hikes << hike_attributes
      end

      # Update URL index -- WTA always shows 30 hikes / page, starting with page_index
      page_index += 30
    end

    # Return an array of hashes, each containing attributes for a scraped hike
    hikes
  end

  def self.scrape_wta_hike_description(url)
    #details = get_page(url).css("#hike-wrapper")
    #{description: details.css("#hike-body-text p").size == 0 ? "" : details.css("#hike-body-text p")[0].text}

    scraped_description = get_page(url).css("#hike-wrapper #hike-body-text p")
    {description: scraped_description.size == 0 ? "" : scraped_description[0].text}
  end
end