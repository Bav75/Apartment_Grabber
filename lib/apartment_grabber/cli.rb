class ApartmentGrabber::CLI

    attr_accessor :user, :scraper

    def run
        welcome
        get_user_specs
        @scraper.scrape_apartments
        show_listings
        help
        user_loop
    end

    def build_url
        puts Rainbow("How many bedrooms (enter number)? :").magenta
        bedrooms = gets.strip.to_i
        puts Rainbow("How many baths (enter number)? :").magenta
        bathrooms = gets.strip.to_i
        puts Rainbow("What is your monthly rent budget? :").magenta
        puts Rainbow("Enter minimum monthly rent (enter number) :").magenta
        min_rent = gets.strip.to_i
        puts Rainbow("Enter maximum monthly rent (enter number):").magenta
        max_rent = gets.strip.to_i

        base_url = "https://sfbay.craigslist.org/search/sfc/apa?hasPic=1"
        custom_url = base_url + "&min_bedrooms=#{bedrooms}&min_bathrooms=#{bathrooms}&min_price=#{min_rent}&max_price=#{max_rent}"

        puts Rainbow("Do you have specific requirements for apartment sqft (enter yes / no)? :").magenta
        sqft_response = gets.strip.downcase
        if sqft_response == "yes"
            puts Rainbow("What are your minimum requirements for sqft (enter number)? :").magenta
            min_sqft = gets.strip.to_i
            puts Rainbow("What are your maximum requirements for sqft (enter number)? :").magenta
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
      - list : displays a list of apartments matching your specifications (either a specific # of listings or all listings)
      - favorites : displays a list of your favorite apartments
      - modify : allows you to modify your search specifications
      - users: displays a list of all active users 
      - switch: prompts the user to select which user to switch to and restarts ApartmentGrabber
      - logout: logs out current user and prompts new user to login
      - exit : exits the program
      HELP
        puts Rainbow(doc).yellow
      end

    def exit
        puts Rainbow("Thanks for using ApartmentGrabber!").magenta
    end

    def welcome
        puts Rainbow("Welcome to Apartment Grabber!").magenta
        puts Rainbow("Please enter your full name.").magenta
        @user != nil ? @user : (@user = ApartmentGrabber::User.create(gets.strip))
    end

    def get_user_specs
        puts Rainbow("Please provide responses below for your desired apartment specifications.").magenta
        @scraper != nil ? @scraper : (@scraper = ApartmentGrabber::Scraper.new(build_url))
    end

    def show_listings
        puts Rainbow("Search resulted in #{ApartmentGrabber::Apartment.all.count} results.").magenta
        puts Rainbow("How many listings would you like to see (enter number or type all)?").magenta
        user_input = gets.strip.downcase
        user_input == "all" ? ApartmentGrabber::Apartment.print_all : ApartmentGrabber::Apartment.print_amount(user_input.to_i)
    end

    def user_loop
        user_input = ""
        while user_input
            user_input = gets.strip 
            case user_input
            when "list"
                show_listings
                help
            when "favorites"
                @user.print_apartment_details
                help
            when "help"
                help
            when "logout"
                @user = nil
                @scraper = nil
                run
                break
            when "users"
                ApartmentGrabber::User.print_all_users
            when "switch"
                puts Rainbow("input name of user to switch to").magenta
                ApartmentGrabber::User.print_all_users
                user_input = gets.strip
                switch_user(user_input)
                @scraper = nil
                run
                break
            when "modify"
                @scraper = nil 
                get_user_specs
                @scraper.scrape_apartments
                show_listings
                help
            when "exit"
                exit
                break
            else
                selection = ApartmentGrabber::Apartment.find_by_index(user_input.to_i)
                @scraper.scrape_apartment_details(selection.url)
                selection.print_details

                puts Rainbow("would you like to add this apartment to your favorites (enter yes / no)?").magenta
                user_input = gets.strip.downcase
                if user_input == "yes"
                    @user.add_favorite(selection)
                end
                help
            end
        end
    end

    def switch_user(name)
        @user = ApartmentGrabber::User.find_by_name(name)
    end

end