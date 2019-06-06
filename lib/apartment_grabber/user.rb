

class ApartmentGrabber::User

    attr_accessor :name

    @@all = []

    def initialize(name)
        @name = name
    end

    def add_favorite(apartment)
        ApartmentGrabber::Favorite.create(self, apartment)
    end

    def favorites
        ApartmentGrabber::Favorite.all.select {|favorite| favorite.user == self}
    end

    def apartments
        favorites.map {|favorite| favorite.apartment}
    end

    def print_apartment_details
        apartments.each do |apartment|
            apartment.print_details
        end
    end

    def save
        @@all << self 
    end

    def self.all
        @@all
    end

    def self.create(name)
        self.new(name).tap do |user|
            user.save
        end
    end



end