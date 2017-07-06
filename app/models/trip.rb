class Trip < ActiveRecord::Base
  validates_presence_of :duration,
                        :start_date_id,
                        :start_station_id,
                        :end_date_id,
                        :end_station_id,
                        :bike_id,
                        :subscription_type,
                        :zipcode_id

  belongs_to :start_station, class_name: "Station", foreign_key: "start_station_id"
  belongs_to :end_station, class_name: "Station", foreign_key: "end_station_id"
  belongs_to :start_date, class_name: "BikeShareDate", foreign_key: "start_date_id"
  belongs_to :end_date, class_name: "BikeShareDate", foreign_key: "end_date_id"
  belongs_to :zipcode, class_name: "Zipcode", foreign_key: "zipcode_id"

  def self.date_with_most_trips
    most_date = group(:start_date).count.max_by do |date, count|
      count
    end

    {date: most_date[0], count: most_date[1]}
  end

  def self.date_with_least_trips
    least_date = group(:start_date).count.min_by do |date, count|
      count
    end

    {date: least_date[0], count: least_date[1]}
  end

  def self.bike_with_most_rides
    most_bike = group(:bike_id).count.max_by do |bike, count|
      count
    end

    {bike: most_bike[0], count: most_bike[1]}
  end

  def self.bike_with_least_rides
    least_bike = group(:bike_id).count.min_by do |bike, count|
      count
    end

    {bike: least_bike[0], count: least_bike[1]}
  end

  def self.subscription_type
    counts = Trip.group(:subscription_type).count
    total_count = counts.values.reduce(:+)
    counts.each do |subscription_type, count|
      counts[subscription_type] = { "Count" => count, "Percentage" => (count.to_f / total_count).round(2)}
    end
# Access in controller route for trip dashboard by data[user]
  end

  def self.rides_by_month
    years = {2013 => {}, 2014 => {}, 2015 => {}}

    group_by_month(years)
    total_by_year(years)
  end

  def self.group_by_month(years)
    grouped = group(:start_date).count

    grouped.each do |date, total|
       month = date.date.strftime('%B')
      if years[date.date.year].has_key?(month)
        years[date.date.year][month] += total
      else
        years[date.date.year][month] = total
      end
    end
    years
  end

  def self.total_by_year(years)
    years.each do |year, month_totals|
      month_totals['total'] = month_totals.values.reduce(:+)
    end
    years
  end

  def self.average_ride_duration
    average(:duration).round(2)
  end

  def self.longest_ride
    Trip.maximum(:duration)
  end

  def self.shortest_ride
    Trip.minimum(:duration)
  end

  def self.most_frequent_zipcode
    zipcode_id = Trip.group(:zipcode_id).count.max_by{|k,v| v}.first
    Zipcode.find(zipcode_id).zipcode
  end

  def self.most_frequent_start_station
    station_id = Trip.group(:start_station_id).count.max_by{|k,v| v}.first
    Station.find(station_id).name
  end

end
