# Running locally
## Getting started

```bash
git clone git@github.com:bwsewell/raleigh-craigslist-apartments.git
cd raleigh-craigslist-apartments
bundle install
```

## Database
If you have a Postgres DB running locally, you can replace the two references to `ENV['DATABASE_URL']` with your credentials: `postgres://user:password@host:port/database_name`. I'm using the `sequel` gem, so you can actually use any relational database you want, but you may have to change some of the code.

## Running the Scraper
Run the following command in the root of the project

```bash
ruby bin/scrape_listings
```

It might take a while locally.

## Viewing the Front-end

Run the following command in the root of the project

```bash
ruby listings.rb
```

This will start a thin web server for Sinatra. You should be able to access the page at `localhost:4567`

# Deploying on Heroku
You can also deploy this repo to Heroku using the button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

This will create a new Heroku app in your account, and run a script after the build to populate the database. The only thing this doesn't do is setup the scraper job to run using Heroku's Scheduler addon. If you do want to setup the scheduler, you can create a job in the dashboard with the command:

```bash
bin/scrape_listings
```

# Quirks
## Listing Scraper Job
The jobs that runs intermittently to scrape all listings drops the listings table at the beginning instead of trying to clean out expired listings at the end, or updating listings that already exist. I currently have this job set to run every hour, therefore I've set the `Cache-Control` header in Sinatra to expire each hour to reduce the possibility of a returning user seeing an incomplete representation of the active listings. It's not perfect, but it works.

## Limit 2500
Looks like Craigslist limits all results for any query to the latest 2500 listings. Because of this, if you visit a page with query parameters for a particular price range, it probably doesn't match the results for that price range if you just scraped all results without any filters.

Examples:
[http://raleigh.craigslist.org/search/apa](http://raleigh.craigslist.org/search/apa) has 2500 results, and if you limit the price range using their url query parameters to listings between $801-$1,000 you'll also get 2500 results (usually) [http://raleigh.craigslist.org/search/apa?min_price=801&max_price=1000&availabilityMode=0](http://raleigh.craigslist.org/search/apa?min_price=801&max_price=1000&availabilityMode=0)

# Notes
Craigslist utilizes a JSON API to populate their map on a search results page:

`http://raleigh.craigslist.org/jsonsearch/apa/?min_price=1&max_price=200&availabilityMode=0`

I thought about using this instead of scraping the pages for HTML elements, but it didn't seems as reliable. It was occasionally missing listing information that was present in the regular list of results.
