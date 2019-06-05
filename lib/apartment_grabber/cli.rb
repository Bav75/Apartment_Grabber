

class ApartmentGrabber::CLI

    # attr_accessor :saved_search

    #saved searches that lets you easily edit, modify what you have searched for 

    def run
        puts "Welcome to Apartment Grabber!"
        puts "Please enter your full name."
        @user = ApartmentGrabber::User.create(gets.strip)

        puts "Please provide responses below for your desired apartment specifications."
        @scraper = ApartmentGrabber::Scraper.new(build_url)

        @scraper.scrape_apartments
        ApartmentGrabber::Apartment.print_all

        # puts "Which apartment would you like additional details on?"
        # user_input = gets.strip.to_i

        help
        user_input = ""
        # while user_input != "exit"
        while user_input
            user_input = gets.strip 
            case user_input
            when "list"
                ApartmentGrabber::Apartment.print_all
            when "favorites"
                @user.print_apartment_details
            when "help"
                help
            when "exit"
                exit
                break
            else
            # puts "Which apartment would you like additional details on (enter number)?"
                selection = ApartmentGrabber::Apartment.find_by_index(user_input.to_i)
                @scraper.scrape_apartment_details(selection.url)
                selection.print_details

                puts "would you like to add this apartment to your favorites (enter yes / no)?"
                user_input = gets.strip.downcase
                if user_input == "yes"
                    @user.add_favorite(selection)
                end
                help
            end
            # puts "Please enter a command:"
            # user_input = gets.strip.downcase
            # case user_input
        end

    end

    def build_url
        #walk the user through their desired apartment specs, collect the input, build the custom URL.

        # specs = []
        puts "How many bedrooms (enter number)? :"
        bedrooms = gets.strip.to_i
        puts "How many baths (enter number)? :"
        bathrooms = gets.strip.to_i
        puts "What is your monthly rent budget? :"
        puts "Enter minimum monthly rent (enter number) :"
        min_rent = gets.strip.to_i
        puts "Enter maximum monthly rent (enter number):"
        max_rent = gets.strip.to_i

        # base_url = "https://sfbay.craigslist.org/search/sfc/apa?hasPic=1&bundleDuplicates=1"
        base_url = "https://sfbay.craigslist.org/search/sfc/apa?hasPic=1"
        custom_url = base_url + "&min_bedrooms=#{bedrooms}&min_bathrooms=#{bathrooms}&min_price=#{min_rent}&max_price=#{max_rent}"

        puts "Do you have specific requirements for apartment sqft (enter yes / no)? :"
        sqft_response = gets.strip.downcase
        if sqft_response == "yes"
            puts "What are your minimum requirements for sqft (enter number)? :"
            min_sqft = gets.strip.to_i
            puts "What are your maximum requirements for sqft (enter number)? :"
            max_sqft = gets.strip.to_i
            custom_url += "&minSqft=#{min_sqft}&maxSqft=#{max_sqft}"
        end

        #finalize custom url 
        custom_url += "&availabilityMode=0&sale_date=all+dates"
    end


    def help
        doc = <<-HELP
      Please enter the number of the apartment listing you are interested in 
      receiving more details for.
      
      If you need further assistance, ApartmentGrabber accepts the following list of commands:
      - help : displays this help message
      - list : displays a list of all apartments matching your specifications
      - favorites : displays a list of your favorite apartments
      - exit : exits the program
      HELP
        puts doc
      end

    def exit
        puts "Thanks for using ApartmentGrabber!"
    end

end