class ApartmentGrabber::Favorite

    attr_accessor :user, :apartment

    @@all = []

    def initialize(user, apartment)
        @user = user
        @apartment = apartment
    end

    def save
        @@all << self 
    end

    def self.create(user, apartment)
        self.new(user, apartment).tap do |favorite|
            favorite.save
        end
    end

    def self.all
        @@all
    end 

end