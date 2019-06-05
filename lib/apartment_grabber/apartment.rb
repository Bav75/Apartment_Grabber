class ApartmentGrabber::Apartment

    attr_accessor :title, :url, :price, :neighborhood, :bedrooms

    @@all = []

    def initialize(title)
        @title = title
        # @url = url
        # @price = price
        # @neighborhood = neighborhood

        # @@all << self 
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