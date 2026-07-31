# config/initializers/pagy.rb

# Require tailwind extra for Tailwind CSS integration
#require "pagy/extras/tailwind"
# Require overflow extra to handle out-of-bound pages gracefully
#require "pagy/extras/overflow"

# Configure Pagy defaults
#Pagy::DEFAULT[:items] = 10 # default items per page
Pagy::OPTIONS[:raise_range_error] = true # show the last page if the requested page is out of bounds
