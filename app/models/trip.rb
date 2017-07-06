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

  def self.rides_at_start_station(station_id)
    Trip.where(start_station_id: station_id).count
  end

  def self.rides_at_end_station(station_id)
    Trip.where(end_station_id: station_id).count
  end

  def self.date_with_most_trips
    most_date = group(:start_date).order('count_id DESC').count(:id).first
    {date: most_date[0], count: most_date[1]}
  end

  def self.date_with_least_trips
    least_date = group(:start_date).order('count_id ASC').count(:id).first

    {date: least_date[0], count: least_date[1]}
  end

  def self.bike_with_most_rides
    most_bike = group(:bike_id).order('count_id DESC').count(:id).first

    {bike: most_bike[0], count: most_bike[1]}
  end

  def self.bike_with_least_rides
    least_bike = group(:bike_id).order('count_id ASC').count(:id).first

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
    grouped = joins(:start_date).group("bike_share_dates.date").count

    grouped.each do |date, total|
       month = date.strftime('%B')
      if years[date.year].has_key?(month)
        years[date.year][month] += total
      else
        years[date.year][month] = total
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
    zipcode_id = group(:zipcode_id).order('count_id DESC').count(:id).first
    Zipcode.find(zipcode_id[0]).zipcode
  end

  def self.most_frequent_start_station
    most_starting_station = group(:start_station).count.max_by do |station, count|
      count
    end

    {station: most_starting_station[0], count: most_starting_station[1]}

    # station_id = Trip.group(:start_station_id).count.max_by{|station,count| count}.first
    # Station.find(station_id).name

    station_id = group(:start_station).order('count_id DESC').count(:id).first
    Station.find(station_id[0]).name

  end

  def self.station_with_most_ending_trips
    most_ending_station = group(:end_station).order('count_id DESC').count(:id).first

    {station: most_ending_station[0], count: most_ending_station[1]}
  end
end
