module Craigslist
  module Listing
    TITLE_SELECTOR = "#titletextonly"
    PRICE_SELECTOR = ".price"
    DESCRIPTION_SELECTOR = "#postingbody"
    DATE_SELECTOR = ".timeago"

    def self.scrape(url)
      listing_doc = Nokogiri::HTML(open(url)) # Fetch listing page

      # Remove the printer-friendly text from the description
      # that includes unecessary QR code stuff
      description = listing_doc.css(DESCRIPTION_SELECTOR)
      description.css('.print-information').remove

      listing = {
        title: listing_doc.css(TITLE_SELECTOR).text,
        price: listing_doc.css(PRICE_SELECTOR).text.gsub(/[^\d\.]/, '').to_f,
        description: description.inner_html,
        date: listing_doc.css(DATE_SELECTOR).first["datetime"],
      }

      LISTINGS.insert(listing) # Insert listing into DB
    rescue
      puts "Scraping #{url} FAILED"
    end
  end
end
