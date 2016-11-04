module Craigslist
  # Connect to our PostgreSQL database
  DB = Sequel.connect(ENV['DATABASE_URL'])

  # Drop the listings table for simplicity if it exists when script runs
  DB.drop_table :listings rescue puts "No listings table to drop"

  # Create the listings table
  DB.create_table :listings do
    primary_key :id
    String :title
    Float :price
    String :description
    DateTime :date
  end

  LISTINGS = DB[:listings]
  BASE_URL = "http://raleigh.craigslist.org"
end
