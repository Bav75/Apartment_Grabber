# ApartmentGrabber

ApartmentGrabber is a CLI program designed as part of the Flatiron School curriculum. This program invovles scraping Craiglist for apartment rental listings for educational purposes. 

## Installation

After cloning the repo, install the dependencies by executing the below command: 

$ bundle install

Execute the interface using the below command:

$ ./bin/apartment_grabber 

## Usage

ApartmentGrabber is a command line interface for accessing Craiglist
apartment listings in the San Francisco Bay Area. 

Upon starting up the program, the user will be prompted for their name which will create a new user object. Users will then be prompted to input
their desired specifications for apartments and will receive a prompt asking for how many listings they'd like to see. 

From here, the user has a number of options at their disposal:
- Enter the number of a listing to access additional details 
- help : displays a help message with instructions on accepted inputs 
- list : displays a list of apartments matching your specifications (either a specific # of listings or all listings)
- favorites : displays a list of your favorite apartments
- modify : allows you to modify your search specifications
- users: displays a list of all active users 
- switch: prompts the user to select which user to switch to and restarts ApartmentGrabber
- logout: logs out current user and prompts new user to login
- exit : exits the program

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bav75/apartment_grabber. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ApartmentGrabber project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bav75/apartment_grabber/blob/master/CODE_OF_CONDUCT.md).
