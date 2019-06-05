class ApartmentGrabber::Scraper

    attr_accessor :url, :max_count

    @@all = [] 

    def initialize(url)
        @url = url 
        @max_count = 500
        @@all << self
    end

    def scrape_apartments
        binding.pry
        page = Nokogiri::HTML(open(@url))
        listings = page.search("ul.rows li.result-row")

        #dealing with pagination
        next_page_url = page.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
        binding.pry

        # get_total_count = page.search("span.totalcount").text[0, 4].to_i

        # while (next_page_url) != "" || false 
        while next_page_url
            # binding.pry
            #constructs the full URL for the next page

            #there is an issue with calling .count on nokogiri elements 
            # if (listings.length < @max_count) && (next_page_url != false)
            #     next_page_url = (@url.split("/search/").first) + next_page_url
            #     #scrape the next page 
            #     next_page_content = Nokogiri::HTML(open(next_page_url))
            #     #grab the apartments on the next page
            #     next_page_listings = next_page_content.search("ul.rows li.result-row")
            #     #add those new apartments to the list of apartments

            next_page_url = (@url.split("/search/").first) + next_page_url
            #scrape the next page 
            next_page_content = Nokogiri::HTML(open(next_page_url))
            #grab the apartments on the next page
            next_page_listings = next_page_content.search("ul.rows li.result-row")
            #add those new apartments to the list of apartments


                #encountered bug using .each on nokogiri elements
            next_page_listings.each do |listing|
                listings << listing
            end

                # for listing in next_page_listings do
                #     listings << listing
                # end

            begin
                next_page_url = next_page_content.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
            rescue NoMethodError
                next_page_url = false 
            end

                # if next_page_content.search("div.paginator.buttongroup.lastpage").empty?
                #     next_page_url = next_page_content.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
                # else
                #     next_page_url = ""
                # end

            # end

            # binding.pry

            # if next_page_content.search("div.paginator.buttongroup.lastpage").empty?
            #     next_page_url = next_page_content.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
            # else
            #     next_page_url = ""
            # end
        end

        #add bedrooms as a property to apartment class
        listings.each do |listing|
            title = listing.search("p.result-info a.result-title").text.strip.downcase.gsub(/[?.!,;]?$/, "")
            unless ApartmentGrabber::Apartment.find_by_title(title)
                apartment = ApartmentGrabber::Apartment.create(title)
                apartment.url = listing.search("a").attr("href").text
                apartment.price = listing.search("p span.result-price").text.split("$").uniq.join("$") #.split chain handles duplicate price values
                apartment.neighborhood = listing.search("p span.result-hood").text
            end
        end
        # for listing in listings do
        #     title = listing.search("p.result-info a.result-title").text.strip.downcase.gsub(/[?.!,;]?$/, "")
        #     unless ApartmentGrabber::Apartment.find_by_title(title)
        #         apartment = ApartmentGrabber::Apartment.create(title)
        #         apartment.url = listing.search("a").attr("href").text
        #         apartment.price = listing.search("p span.result-price").text.split("$").uniq.join("$") #.split chain handles duplicate price values
        #         apartment.neighborhood = listing.search("p span.result-hood").text
        #     end
        # end

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