require 'sinatra'
require 'sequel'
require 'pg'

before do
  cache_control :public, :max_age => 3600
end

get '/' do
  db = Sequel.connect(ENV['DATABASE_URL'])

  @listings = db[:listings]
  @ranges = []
  @total_listings = @listings.count

  @max_price = 5000
  price = 0
  interval = 200

  begin
    @ranges << {
      min: price,
      max: price + interval,
      count: @listings.where('price > ? AND price <= ?', price, price + interval).count
    }
    price += interval
  end until price > @max_price

  haml :index
end
