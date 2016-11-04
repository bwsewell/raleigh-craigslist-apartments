# Running locally
If you have a Postgres DB running locally, you can replace the two references to `ENV['DATABASE_URL']` with your credentials: `postgres://user:password@host:port/database_name`

# Deploying on Heroku
You can also deploy this repo to Heroku using the button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

This will create a new Heroku app in your account, and run a script after the build to populate the database. The only thing this doesn't do is setup the scraper job to run using Heroku's Scheduler addon. If you do want to setup the scheduler, you can create a job in the dashboard with the command:

```bash
bin/scrape_listings
```

# Quirks
The jobs that runs intermittently to scrape all listings drops the listings table at the beginning instead of trying to clean out expired listings at the end, or updating listings that already exist. I currently have this job set to run every hour, therefore I've set the `Cache-Control` header in Sinatra to expire each hour to reduce the possibility of a returning user seeing an incomplete representation of the active listings. It's not perfect, but it works.

# Notes
Craigslist utilizes a JSON API to populate their map on a search results page:

`http://raleigh.craigslist.org/jsonsearch/apa/?min_price=1&max_price=200&availabilityMode=0`

I thought about using this instead of scraping the pages for HTML elements, but it didn't seems as reliable. It was occasionally missing listing information that was present in the regular list of results.
