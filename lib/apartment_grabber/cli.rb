class ApartmentGrabber::CLI

    attr_accessor :user, :scraper

    def run
        welcome
        get_user_specs

        # puts "Please provide responses below for your desired apartment specifications."
        # @scraper = ApartmentGrabber::Scraper.new(build_url)

        @scraper.scrape_apartments
        show_listings

        # ApartmentGrabber::Apartment.print_all

        help
        user_input = ""
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
        end

    end

    def build_url
        puts "How many bedrooms (enter number)? :"
        bedrooms = gets.strip.to_i
        puts "How many baths (enter number)? :"
        bathrooms = gets.strip.to_i
        puts "What is your monthly rent budget? :"
        puts "Enter minimum monthly rent (enter number) :"
        min_rent = gets.strip.to_i
        puts "Enter maximum monthly rent (enter number):"
        max_rent = gets.strip.to_i

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

    def welcome
        puts "Welcome to Apartment Grabber!"
        puts "Please enter your full name."
        @user = ApartmentGrabber::User.create(gets.strip)
    end

    def get_user_specs
        puts "Please provide responses below for your desired apartment specifications."
        @scraper = ApartmentGrabber::Scraper.new(build_url)
    end

    def show_listings
        puts "Search resulted in #{ApartmentGrabber::Apartment.all.count} results."
        puts "How many listings would you like to see (enter number or type all)?"
        user_input = gets.strip.downcase
        user_input == "all" ? ApartmentGrabber::Apartment.print_all : ApartmentGrabber::Apartment.print_amount(user_input.to_i)
    end

    def switch_user

    end

end