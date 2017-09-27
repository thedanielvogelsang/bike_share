require './app/models/station.rb'
require './app/models/bikesharedate.rb'
require './app/models/trip.rb'
require './app/models/zipcode.rb'
require './app/models/weather_condition.rb'
require 'csv'
require 'pry'
# This method is written with weather conditions in mind, so we don't have to
# delete keys on every iteration when seeding
def delete_columns(path, column_headers)
  table = CSV.table(path)
  column_headers.each do |column_header|
    table.delete(column_header) #deletes columns
  end
  table
end

Station.destroy_all
system 'Say "Finished Destroying Stations"'
Trip.destroy_all
system 'Say "Finished Destroying Trips"'
WeatherCondition.destroy_all
system 'Say "Finished Destroying WeatherConditions"'

start_time = Time.now
puts start_time
sleep 3
stations = CSV.read "./db/csv/station.csv", headers: true, header_converters: :symbol
stations = delete_columns("./db/csv/station.csv", [:lat, :long])

stations.each do |row|
  row = row.to_h
  row[:installation_date_id] = BikeShareDate.seed_by_date(row.delete(:installation_date))
  Station.create!(row)
end
system 'Say "Finished Seeding Stations"'

binding.pry
trips = CSV.open "./db/csv/trip.csv", headers: true, header_converters: :symbol
trips.each do |row|
  row = row.to_h
  row[:start_date_id] = BikeShareDate.seed_by_date(row.delete(:start_date))
  row[:start_station_id] = Station.id_by_name(row.delete(:start_station_name))
  row[:end_date_id] = BikeShareDate.seed_by_date(row.delete(:end_date))
  row[:end_station_id] = Station.id_by_name(row.delete(:end_station_name))
  row[:zipcode_id] = Zipcode.create_zipcode(row.delete(:zip_code))
  Trip.create!(row)
end

system 'Say "Finished Seeding Trips"'

weather_conditions = delete_columns("./db/csv/weather.csv", [:max_dew_point_f,
                                                      :mean_dew_point_f,
                                                      :min_dew_point_f,
                                                      :max_humidity,
                                                      :min_humidity,
                                                      :max_sea_level_pressure_inches,
                                                      :mean_sea_level_pressure_inches,
                                                      :min_sea_level_pressure_inches,
                                                      :max_visibility_miles,
                                                      :min_visibility_miles,
                                                      :max_wind_speed_mph,
                                                      :max_gust_speed_mph,
                                                      :cloud_cover,
                                                      :events,
                                                      :wind_dir_degrees,
                                                      :zip_code]
                                                      )

weather_conditions.each do |row|
  row = row.to_h
  row[:date_id] = BikeShareDate.seed_by_date(row.delete(:date))
  row[:max_temp_f] = WeatherCondition.clean_float(row.delete(:max_temperature_f))
  row[:mean_temp_f] = WeatherCondition.clean_float(row.delete(:mean_temperature_f))
  row[:min_temp_f] = WeatherCondition.clean_float(row.delete(:min_temperature_f))
  row[:mean_humidity] = WeatherCondition.clean_float(row.delete(:mean_humidity))
  row[:mean_visibility] = WeatherCondition.clean_float(row.delete(:mean_visibility_miles))
  row[:mean_wind_speed] = WeatherCondition.clean_float(row.delete(:mean_wind_speed_mph))
  row[:precipitation] = WeatherCondition.clean_float(row.delete(:precipitation_inches))
  WeatherCondition.create!(row)
end
system 'Say "Finished Seeding Weather Conditions"'

puts Time.now - start_time
