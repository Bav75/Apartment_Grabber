class ApartmentGrabber::Apartment

    attr_accessor :title, :url, :price, :sqft, :neighborhood, :bedrooms, :baths, :availability, :amenities, :description
 
    @@all = []

    def initialize(title)
        @title = title
        @amenities = []
    end

    def print_details
        doc = <<-HEREDOC
        title = #{self.title}
        price = #{self.price}
        sqft = #{self.sqft}
        bedrooms = #{self.bedrooms}
        baths = #{self.baths}
        neighborhood = #{self.neighborhood}
        amenities = #{self.amenities}
        description = #{self.description}
        HEREDOC
        puts doc
    end

    def save
        @@all << self 
    end

    def favorites
        ApartmentGrabber::Favorite.all.select {|favorite| favorite.apartment == self}
    end

    def users
        favorites.map {|favorite| favorite.user}
    end

    def self.all
        @@all
    end

    def self.create(title)
        self.new(title).tap do |apartment|
            apartment.save
        end
    end

    def self.create_and_populate_details_from_listing(listing)
        title = listing.search("p.result-info a.result-title").text.strip.downcase.gsub(/[?.!,;]?$/, "")
        unless self.find_by_title(title)
            apartment = self.create(title)
            apartment.url = listing.search("a").attr("href").text
            begin
                apartment.sqft = listing.search("span.housing").text.strip.split("\n")[1].strip.gsub("ft2 -", "").to_i # != "") ? (listing.search("span.housing").text.strip.split("\n")[1].strip.gsub("ft2 -", "").to_i) : "Not available"
            rescue NoMethodError
                apartment.sqft = "Not available"
            ensure
                apartment.price = listing.search("p span.result-price").text.split("$").uniq.join("$")
                apartment.neighborhood = (listing.search("p span.result-hood").text.downcase.strip != "") ? (listing.search("p span.result-hood").text.downcase.strip) : (listing.search("p span.nearby").text.downcase.strip)
                apartment.bedrooms = listing.search("p span.housing").text.strip.gsub("br", "").gsub(" -", "").to_i
            end
        end
    end

    def self.find_by_title(title)
        @@all.detect {|apartment| apartment.title == title}
    end

    def self.find_by_index(index)
        @@all[index - 1]
    end

    def self.find_by_url(url)
        @@all.detect {|apartment| apartment.url == url}
    end

    def self.print_all
        @@all.each.with_index(1) do |apartment, index|
            doc = <<-HEREDOC

            #{index}. #{apartment.title}
            price = #{apartment.price}
            sqft = #{apartment.sqft}
            bedrooms = #{apartment.bedrooms}
            neighborhood = #{apartment.neighborhood}

            HEREDOC
            puts doc
        end
    end

    def self.print_amount(amount)
        list = @@all[0, amount]
        list.each.with_index(1) do |apartment, index|
            doc = <<-HEREDOC

            #{index}. #{apartment.title}
            price = #{apartment.price}
            sqft = #{apartment.sqft}
            bedrooms = #{apartment.bedrooms}
            neighborhood = #{apartment.neighborhood}

            HEREDOC
            puts doc
        end
    end
end