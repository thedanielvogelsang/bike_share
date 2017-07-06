class BikeShareDate < ActiveRecord::Base
  validates_presence_of :date
  has_many :start_trips, class_name: "Trip", foreign_key: 'start_date_id'

  def self.create_by_date(date)
    # require "pry"; binding.pry
    find_or_create_by(date: Date.strptime(date, '%Y-%m-%d')).id
  end

  def self.seed_by_date(date)
    find_or_create_by(date: Date.strptime(date, '%m/%d/%Y')).id
  end
end
