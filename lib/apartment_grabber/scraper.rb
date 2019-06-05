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

        #dealing with pagination
        next_page_url = page.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
        # binding.pry
        while next_page_url != "" || false 
            # binding.pry
            #constructs the full URL for the next page
            next_page_url = (@url.split("/search/").first) + next_page_url
            #scrape the next page 
            next_page_content = Nokogiri::HTML(open(next_page_url))
            #grab the apartments on the next page
            next_page_listings = next_page_content.search("ul.rows li.result-row")
            #add those new apartments to the list of apartments
            next_page_listings.each do |listing|
                listings << listing
            end

            binding.pry

            if next_page_content.search("div.paginator.buttongroup.lastpage").empty?
                next_page_url = next_page_content.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
            else
                next_page_url = ""
            end
        end

        listings.each do |listing|
            title = listing.search("p.result-info a.result-title").text.strip.downcase.gsub(/[?.!,;]?$/, "")
            unless ApartmentGrabber::Apartment.find_by_title(title)
                apartment = ApartmentGrabber::Apartment.create(title)
                apartment.url = listing.search("a").attr("href").text
                apartment.price = listing.search("p span.result-price").text.split("$").uniq.join("$") #.split chain handles duplicate price values
                apartment.neighborhood = listing.search("p span.result-hood").text
            end
        end

        # binding.pry

        # url = search("a").attr("href").text #prefix with apartments.each do 
        # price = search("p span.result-price").text
        # neighborhood = search("p span.result-hood").text

    end

    # def scrape_apartment_details(apartment)

    # end

    def self.all
        @@all
    end

end