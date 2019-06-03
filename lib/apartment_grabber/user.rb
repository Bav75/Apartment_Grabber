

class ApartmentGrabber::User

    attr_accessor :name, :favorites

    @@all = []

    def initialize(name)
        @name = name
        @favorites = []

        @@all << self 
    end

    def self.all
        @@all
    end

end