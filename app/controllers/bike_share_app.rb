require 'will_paginate'
require 'will_paginate/active_record'
require "pry"


class BikeShareApp < Sinatra::Base
  include WillPaginate::Sinatra::Helpers

  get '/' do
    erb :"dashboard"
  end

  get '/stations' do
    @stations = Station.all[0..29]
    erb :"/stations/index"
  end

  get '/stations/index-2' do
    @stations = Station.all[30..68]
    erb :"/stations/index-2"
  end

  get '/stations/index-3' do
    @stations = Station.all[69..-1]
    erb :"/stations/index-3"
  end

  get '/stations/new' do
    erb :"/stations/new"
  end

  post '/stations' do
    date = params[:station][:installation_date_id]
    params[:station][:installation_date_id] = BikeShareDate.create_by_date(date)
    @station = Station.create(params[:station])
    redirect :"/stations/#{@station.id}"
  end

  get '/stations/:id' do |id|
    @station = Station.find(id)
    @rides_started = Trip.rides_at_start_station(@station.id)
    @rides_ended = Trip.rides_at_end_station(@station.id)
    @most_trips_started = @station.most_trip_date
    @most_end_station = @station.start_station_with_most_rides
    @most_start_station = @station.origination_station
    @most_zipcode = @station.most_frequent_zipcode
    @most_bike_id = @station.starting_bike_id
    erb :'/stations/show'
  end

  get '/stations/:id/edit' do |id|
    @station = Station.find(id)
    erb :"/stations/edit"
  end

  put '/stations/:id' do
    date = params[:station][:installation_date_id]
    params[:station][:installation_date_id] = BikeShareDate.create_by_date(date)
    @station = Station.update(params[:id], params[:station])
    redirect "/stations/#{@station.id}"
  end

  delete '/stations/:id' do |id|
    @station = Station.destroy(id)
    redirect '/stations'
  end

  get '/station-dashboard' do
    @total_stations = Station.total_count
    @most_bikes_station = Station.station_with_most_bikes
    @fewest_bikes_station = Station.stations_with_fewest_bikes_available
    @average_bikes = Station.average_bikes_available_per_station
    @newest_station = Station.most_recently_installed
    @oldest_station = Station.oldest_station
    @most_bikes = Station.most_number_of_available_bikes
    @least_bikes = Station.least_number_of_available_bikes
    erb :"/stations/dashboard"
  end

  get '/stations/:id/bs.png' do
    redirect "bs.png"
  end

  get '/trips' do
    @trips = Trip.paginate(:page => params[:page], :per_page => 30)
    erb :"/trips/index"
  end

  get '/trips/new' do
    @stations = Station.all
    @bikes = Trip.pluck(:bike_id).uniq
    erb :"/trips/new"
  end

  get '/trips/:id' do |id|
    @trip = Trip.find(id)
    erb :"/trips/show"
  end

  get '/trips/:id/edit' do |id|
    @trip = Trip.find(id)
    @stations = Station.all
    @bikes = Trip.pluck(:bike_id).uniq
    erb :"/trips/edit"
  end

  put "/trips/:id" do |id|
    end_date = params[:trip][:end_date_id]
    params[:trip][:end_date_id] = BikeShareDate.create_by_date(end_date)
    start_date = params[:trip][:start_date_id]
    params[:trip][:start_date_id] = BikeShareDate.create_by_date(start_date)

    zipcode_id = params[:trip][:zipcode_id]
    params[:trip][:zipcode_id] = Zipcode.create_zipcode(zipcode_id)

    @trip = Trip.update(id, params[:trip])
    redirect "/trips/#{id}"
  end

  post '/trips' do
    start_date = params[:trip][:start_date_id]
    params[:trip][:start_date_id] = BikeShareDate.create_by_date(start_date)

    end_date = params[:trip][:end_date_id]
    params[:trip][:end_date_id] = BikeShareDate.create_by_date(end_date)

    zipcode = params[:trip][:zipcode_id]
    params[:trip][:zipcode_id] = Zipcode.create_zipcode(zipcode).id

    Trip.create!(params[:trip])

    redirect('/trips')
  end

  delete '/trips/:id' do |id|
    Trip.destroy(id)
    redirect('/trips')
  end

  get '/trip-dashboard' do
    @ave_duration_ride = Trip.average_ride_duration

    @longest_ride = Trip.longest_ride
    @shortest_ride = Trip.shortest_ride

    @most_frequent_zipcode = Trip.most_frequent_zipcode

    @most_start_station_name = Trip.most_frequent_start_station
    @most_end_station = Trip.station_with_most_ending_trips

    @subscriber_count = Trip.subscription_type["Subscriber"]["Count"]
    @customers_count = Trip.subscription_type["Customer"]["Percentage"]*100
    @subscriber_percent = Trip.subscription_type["Subscriber"]["Count"]
    @customer_percent = Trip.subscription_type["Customer"]["Percentage"]*100
    # hash for [:bike] [:count]
    @bike_most_rides = Trip.bike_with_most_rides[:count]
    @bike_least_rides = Trip.bike_with_least_rides[:count]

    @date_most_trips_count = Trip.date_with_most_trips[:count]
    @date_most_trips_date = Trip.date_with_most_trips[:date].date

    @date_few_trips_count = Trip.date_with_least_trips[:count]
    @date_few_trips_date = Trip.date_with_least_trips[:date].date

    #hash for ["month_name"]
    @rides_by_month_2013 = Trip.rides_by_month[2013]
    @total_rides_2013 = Trip.rides_by_month[2013]["total"]
    @rides_by_month_2014 = Trip.rides_by_month[2014]
    @total_rides_2014 = Trip.rides_by_month[2014]["total"]
    @rides_by_month_2015 = Trip.rides_by_month[2015]
    @total_rides_2015 = Trip.rides_by_month[2015]["total"]

    erb :"/trips/dashboard"
  end

  get '/weather_conditions' do
    @weather_conditions = WeatherCondition.paginate(:page => params[:page])
    erb :"weather_conditions/index"
  end

  get '/weather_conditions/new' do
    erb :"/weather_conditions/new"
  end

  post '/weather_conditions' do
    date = params[:weather_conditions][:date_id]
    params[:weather_conditions][:date_id] = BikeShareDate.create_by_date(date)
    @weather_conditions = WeatherCondition.create(params[:weather_conditions])
    redirect :"/weather_conditions/#{@weather_conditions.id}"
  end

  get '/weather_conditions/:id' do |id|
    @weather_condition = WeatherCondition.find(id)

    erb :"weather_conditions/show"
  end

  delete '/weather_conditions/:id' do |id|
    WeatherCondition.destroy(id)
    redirect('/weather_conditions')
  end
end
