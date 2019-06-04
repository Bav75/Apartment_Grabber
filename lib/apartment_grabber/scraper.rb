class ApartmentGrabber::Scraper

    attr_accessor :url 

    @@all = [] 

    def initialize(url)
        @url = url 
        @@all << self
    end

    def self.all
        @@all
    end

end