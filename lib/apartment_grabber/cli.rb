

class ApartmentGrabber::CLI

    attr_accessor :saved_search

    #saved searches that lets you easily edit, modify what you have searched for 

    def run
        puts "Welcome to Apartment Grabber!"
        puts "Please enter your full name."
        ApartmentGrabber::User.new(gets.strip)
        puts "Please provide responses below for your desired apartment specifications."
        build_url
    end

    def build_url
        #walk the user through their desired apartment specs, collect the input, build the custom Zillow URL.

        # specs = []

        #mandatory features 
        puts "What is your desired US state (enter initials)? :"
        state = gets.strip.downcase.gsub(" ", "-")
        # hyphen (-) accounts for scenarios where names are more than one word
        puts "What is your desired city (enter fullname with spaces)? :"
        city = gets.strip.downcase.gsub(" ", "-")
        # hyphen (-) accounts for scenarios where names are more than one word
        puts "How many bedrooms (enter number)? :"
        bedrooms = gets.strip.to_i
        puts "How many baths (enter number)? :"
        baths = gets.strip.to_i
        puts "What is your monthly rent budget? :"
        puts "Enter minimum monthly rent :"
        min_rent = gets.strip.to_i
        puts "Enter maximum monthly rent :"
        max_rent = gets.strip.to_i

        #extra features 
        extra_features = {}
        puts "Do you require accommodation for pets (enter yes / no)? :"
        extra_features[:pets] = gets.strip.downcase
        puts "Do you require in-unit laundry (enter yes / no)? :"
        extra_features[:laundry] = gets.strip.downcase
        puts "Do you require a parking space (enter yes / no)? :"
        extra_features[:parking] = gets.strip.downcase

        base_url = "https://www.zillow.com/homes/for_rent/"
        custom_url = base_url + "#{city}-#{state}/apartment_duplex_type/#{bedrooms}-_beds/#{baths}-_baths/#{min_rent}-#{max_rent}_mp"
        
        extra_features.each do |feature, response|
            if response == "yes"
                custom_url += "/1-_#{feature.to_s}"
            end
        end

        custom_url
        
        binding.pry

    end

    # def build_url
    #     get_specs
    #     base_url = "https://www.zillow.com/homes/for_rent/"
    #     custom_url = base_url + parking
    #     custom_url
    #     binding.pry

    # end


end