RSpec.describe "user visits station show page" do
  it "and they see all information for that station" do
    date = BikeShareDate.create(date: Date.strptime('1/1/2012', '%m/%d/%Y'))
    date = BikeShareDate.create(date: Date.strptime('2/1/2012', '%m/%d/%Y'))

    station = Station.create(name: "A", dock_count: 1, installation_date_id: 1, city: "Chicago")

    trip_1 = Trip.create(duration: 75, start_date_id: 2, start_station_id: 1, end_date_id: 2, end_station_id: 1, bike_id: 25, subscription_type: "customer", zipcode_id: 1)
    trip_2 = Trip.create(duration: 75, start_date_id: 2, start_station_id: 1, end_date_id: 2, end_station_id: 1, bike_id: 25, subscription_type: "customer", zipcode_id: 1)
    trip_3 = Trip.create(duration: 75, start_date_id: 2, start_station_id: 1, end_date_id: 3, end_station_id: 1, bike_id: 23, subscription_type: "customer", zipcode_id: 2)
    trip_4 = Trip.create(duration: 75, start_date_id: 1, start_station_id: 1, end_date_id: 3, end_station_id: 2, bike_id: 12, subscription_type: "customer", zipcode_id: 3)

    zip = Zipcode.create(zipcode: "80215")
    zip = Zipcode.create(zipcode: "90401")
    zip = Zipcode.create(zipcode: "90210")


    visit("/stations/#{station.id}")
    # save_and_open_page
    expect(page).to have_content(station.name)
    expect(page).to have_content(station.dock_count)
    expect(page).to have_content(station.city)
    expect(page).to have_content(station.installation_date.date)
    expect(page).to have_content(4)
    expect(page).to have_content(3)
    expect(page).to have_content("2012-01-01")
    expect(page).to have_content("Destination Station: A")
    expect(page).to have_content("Origin Station: A")
    expect(page).to have_content("Station: 80215")
    expect(page).to have_content("Bike Most Frequently Used at this Station: 25")
  end
end