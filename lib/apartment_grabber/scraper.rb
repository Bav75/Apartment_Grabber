class ApartmentGrabber::Scraper

    attr_accessor :url 

    @@all = [] 

    def initialize(url)
        @url = url 
        @@all << self
    end

    def scrape_apartment_list

        page = Nokogiri::HTML(open(@scraper.url))
        apartments = page.search("ul.rows li.result-row")
        # apartments.children.search("li.result-row")[1]
        url = search("a").attr("href").text #prefix with apartments.each do 
        price = search("p span.result-price").text
        neighborhood = search("p span.result-hood").text


        # next_page.css("a.button.next").attr("href").text


        #dealing with pagination
        #returns nil if nothing found 
        next_page = page.search("div.paginator.buttongroup span.buttons a.button.next").attr("href").text
        if next_page
            #constructs the full URL for the next page
            next_page = (@scraper.url.split("/search/").first) + next_page
            #scrape the next page 
            next_page_content = Nokogiri::HTML(open(next_page))
            #grab the apartments on the next page
            next_page_apartments = next_page_content.search("ul.rows li.result-row")
            #add those new apartments to the list of apartments
            next_page_apartments.each do |apartment|
                apartments << apartment
            end


    end

    def scrape_apartment_details(apartment)

    def self.all
        @@all
    end

end