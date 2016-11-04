module Craigslist
  module Search
    CATEGORY = "apa"
    SEARCH_URL = BASE_URL + "/search/" + CATEGORY
    SEARCH_RESULTS_SELECTOR = '.result-row > a'

    def self.scrape
      doc = Nokogiri::HTML(open(SEARCH_URL)) # Fetch search results page

      results = doc.css(SEARCH_RESULTS_SELECTOR) # Selects links to listings
      offset = 0

      until results.empty?
        results.each do |result|
          Listing.scrape(BASE_URL + result["href"])
        end

        puts "Page #{offset} DONE"
        offset += 100
        doc = Nokogiri::HTML(open(SEARCH_URL + "?s=#{offset}"))
        results = doc.css(SEARCH_RESULTS_SELECTOR)
      end
    end
  end
end
