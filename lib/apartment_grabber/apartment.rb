class ApartmentGrabber::Apartment

    attr_accessor :title, :url, :price, :neighborhood, :bedrooms, :baths, :availability, :amenities, :description
 
    @@all = []

    def initialize(title)
        @title = title
        @amenities = []
    end

    def print_details
        doc = <<-HEREDOC
        title = #{self.title}
        price = #{self.price}
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

    def self.all
        @@all
    end

    def self.create(title)
        self.new(title).tap do |apartment|
            apartment.save
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
                bedrooms = #{apartment.bedrooms}
                neighborhood = #{apartment.neighborhood}

            HEREDOC
            puts doc
        end
    end


end