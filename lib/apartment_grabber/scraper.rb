class ApartmentGrabber::Scraper

    attr_accessor :url

    @@all = [] 

    def initialize(url)
        @url = url 
        @@all << self
    end

    def scrape_apartments
        page = Nokogiri::HTML(open(@url))
        listings = page.search("ul.rows li.result-row")

        begin
            next_page_url = page.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
        rescue NoMethodError
            next_page_url = false 
        end

        listings.each do |listing|
            title = listing.search("p.result-info a.result-title").text.strip.downcase.gsub(/[?.!,;]?$/, "")
            unless ApartmentGrabber::Apartment.find_by_title(title)
                apartment = ApartmentGrabber::Apartment.create(title)
                apartment.url = listing.search("a").attr("href").text
                apartment.price = listing.search("p span.result-price").text.split("$").uniq.join("$")
                apartment.neighborhood = listing.search("p span.result-hood").text.downcase.strip
                apartment.bedrooms = listing.search("p span.housing").text.strip.gsub("br", "").gsub(" -", "").to_i
            end
        end

        while next_page_url
            next_page_url = (@url.split("/search/").first) + next_page_url
            next_page_content = Nokogiri::HTML(open(next_page_url))
            next_page_listings = next_page_content.search("ul.rows li.result-row")
            next_page_listings.each do |listing|
                title = listing.search("p.result-info a.result-title").text.strip.downcase.gsub(/[?.!,;]?$/, "")
                unless ApartmentGrabber::Apartment.find_by_title(title)
                    apartment = ApartmentGrabber::Apartment.create(title)
                    apartment.url = listing.search("a").attr("href").text
                    apartment.price = listing.search("p span.result-price").text.split("$").uniq.join("$")
                    apartment.neighborhood = listing.search("p span.result-hood").text.downcase.strip
                    apartment.bedrooms = listing.search("p span.housing").text.strip.gsub("br", "").gsub(" -", "").to_i
                end
            end

            begin
                next_page_url = next_page_content.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
            rescue NoMethodError
                next_page_url = false 
            end
        end
    end

    def scrape_apartment_details(apartment_url)
        page = Nokogiri::HTML(open(apartment_url))
        apartment = ApartmentGrabber::Apartment.find_by_url(apartment_url)
        apartment.description = page.search("section#postingbody").text

        apartment_attributes = page.search("div.mapAndAttrs p.attrgroup span")
        apartment_attributes.each do |attribute|
            if attribute.text.include?("Ba")
                apartment.baths = attribute.text.split("/")[1].strip.chomp("Ba")
            elsif attribute.text.include?("available")
                apartment.availability = attribute.text
            else
                apartment.amenities << attribute.text
            end
        end
        # binding.pry 
    end

    def self.all
        @@all
    end

end