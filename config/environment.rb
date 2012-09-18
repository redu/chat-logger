# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ChatLogger::Application.initialize!

Time::DATE_FORMATS[:date] = "%d/%m/%y"
Time::DATE_FORMATS[:time] = "%H:%M:%S"
