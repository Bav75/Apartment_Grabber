

class ApartmentGrabber::CLI

    def run
        puts "Welcome to Apartment Grabber!"
        puts "Please enter your full name."
        ApartmentGrabber::User.new(gets.strip)
        puts "Please provide responses below for your desired apartment specifications."
        build_url
    end

    def build_url
        #walk the user through their desired apartment specs, collect the input, build the custom Zillow URL.

        puts "What is your desired US state (enter initials)? :"
        state = gets.strip.downcase
        puts "What is your desired city (enter fullname with spaces)? :"
        city = gets.strip.downcase
        puts "How many bedrooms (enter number)? :"
        bedrooms = gets.strip.to_i
        puts "How many baths (enter number)? :"
        baths = gets.strip.to_i
        puts "What is your monthly rent budget? :"
        puts "Enter minimum monthly rent :"
        min_rent = gets.strip.to_i
        puts "Enter maximum monthly rent :"
        max_rent = gets.strip.to_i
        puts "Do you require accommodation for pets (enter yes / no)? :"
        pets = gets.strip
        puts "Do you require in-unit laundry (enter yes / no)? :"
        laundry = gets.strip
        puts "Do you require a parking space (enter yes / no)? :"
        parking = gets.strip

        binding.pry
        custom_url = "this_is_my_custom_url"

    end

end