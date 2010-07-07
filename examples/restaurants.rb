class Rating
  include Pincaster::Record

  property :rate, Float
  property :votes, Fixnum
  property :voters, Array
end

class Restaurant
  include Pincaster::GeoRecord

  property :name,     String
  property :address,  String
  property :rating,   Rating
end

Restaurant.all.each do |restaurant|
  puts "Restaurant: #{restaurant.name}"
  puts "  rate: #{restaurant.rating.rate} (#{restaurant.rating.votes} votes)"
  puts "  geo:  #{restaurant.geo.latitude} - #{restaurant.geo.longitude}"

end
