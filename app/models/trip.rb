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
    group(:start_date).count.max_by do |date, count|
      count
    end
  end

  def self.date_with_least_trips
    group(:start_date).count.min_by do |date, count|
      count
    end
  end

  def self.bike_with_most_rides
    group(:bike_id).count.max_by do |bike, count|
      count
    end
  end

  def self.bike_with_least_rides
    group(:bike_id).count.min_by do |bike, count|
      count
    end
  end
end
