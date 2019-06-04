

class ApartmentGrabber::User

    attr_accessor :name, :favorites

    @@all = []

    def initialize(name)
        @name = name
        @favorites = []

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