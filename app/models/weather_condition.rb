class WeatherCondition < ActiveRecord::Base

  validates_presence_of :date_id, :max_temp_f, :mean_visibility, :mean_humidity,
                        :precipitation, :mean_temp_f, :mean_wind_speed,
                        :min_temp_f


  belongs_to :date, class_name: "BikeShareDate", foreign_key: "date_id"

  def self.clean_float(input)
    if input.nil?
      0.0
    else
      input
    end
  end
end
