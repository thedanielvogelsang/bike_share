RSpec.describe "User creates a new weather condition" do
  it "and see the show page for the new condition" do
    BikeShareDate.create(date: Date.strptime('4/7/1984', '%m/%d/%Y'))

    WeatherCondition.create(date_id: 1, max_temp_f: 75.0, mean_visibility: 10.0, mean_humidity: 51.0, precipitation: 0.23, mean_temp_f: 62.0, mean_wind_speed: 22.0, min_temp_f: 59.0)
    WeatherCondition.create(date_id: 1, max_temp_f: 85.0, mean_visibility: 4.0, mean_humidity: 23.0, precipitation: 0.23, mean_temp_f: 62.0, mean_wind_speed: 22.0, min_temp_f: 59.0)

    visit("/weather_conditions/new")
    fill_in("weather_conditions[date_id]", with: 1)
    fill_in("weather_conditions[max_temp_f]", with: 100)
    fill_in("weather_conditions[mean_temp_f]", with: 90)
    fill_in("weather_conditions[min_temp_f]", with: 85)
    fill_in("weather_conditions[mean_humidity]", with: 45)
    fill_in("weather_conditions[mean_visibility]", with: 1)
    fill_in("weather_conditions[mean_wind_speed]", with: 5)
    fill_in("weather_conditions[precipitation]", with: 0.23)
    click_button("Add Weather Condition")

    save_and_open_page

    station = Station.last
    expect(current_path).to eq("/weather_condtions/#{station.id}")
    expect(page).to have_content("85")
  end
end
