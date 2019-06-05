class ApartmentGrabber::Scraper

    attr_accessor :url, :max_count

    @@all = [] 

    def initialize(url)
        @url = url 
        @max_count = 500
        @@all << self
    end

    def scrape_apartments
        page = Nokogiri::HTML(open(@url))
        listings = page.search("ul.rows li.result-row")

        next_page_url = page.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text

        listings.each do |listing|
            title = listing.search("p.result-info a.result-title").text.strip.downcase.gsub(/[?.!,;]?$/, "")
            unless ApartmentGrabber::Apartment.find_by_title(title)
                apartment = ApartmentGrabber::Apartment.create(title)
                apartment.url = listing.search("a").attr("href").text
                apartment.price = listing.search("p span.result-price").text.split("$").uniq.join("$")
                apartment.neighborhood = listing.search("p span.result-hood").text.strip
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
                    apartment.neighborhood = listing.search("p span.result-hood").text.strip
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

    # def scrape_apartment_details(apartment)

    # end

    def self.all
        @@all
    end

end