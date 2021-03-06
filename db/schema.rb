# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170706041533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bike_share_dates", force: :cascade do |t|
    t.date "date"
  end

  create_table "stations", force: :cascade do |t|
    t.text    "name"
    t.integer "dock_count"
    t.text    "city"
    t.integer "installation_date_id"
  end

  create_table "trips", force: :cascade do |t|
    t.integer "duration"
    t.integer "start_date_id"
    t.integer "start_station_id"
    t.integer "end_date_id"
    t.integer "end_station_id"
    t.integer "bike_id"
    t.text    "subscription_type"
    t.integer "zipcode_id"
  end

  create_table "weather_conditions", force: :cascade do |t|
    t.integer "date_id"
    t.float   "max_temp_f"
    t.float   "mean_temp_f"
    t.float   "min_temp_f"
    t.float   "mean_humidity"
    t.float   "mean_visibility"
    t.float   "mean_wind_speed"
    t.float   "precipitation"
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string "zipcode"
  end

end
