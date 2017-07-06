RSpec.describe "user edits station" do
  it "with valid attributes" do
    date = BikeShareDate.create(date: Date.strptime('1/1/2012', '%m/%d/%Y'))
    date_2 = BikeShareDate.create(date: Date.strptime('2/5/2017', '%m/%d/%Y'))
    date_3 = BikeShareDate.create(date: Date.strptime('4/12/2014', '%m/%d/%Y'))
    date_4 = BikeShareDate.create(date: Date.strptime('6/25/2017', '%m/%d/%Y'))
    date_5 = BikeShareDate.create(date: Date.strptime('2/1/2012', '%m/%d/%Y'))

    station_a = Station.create(name: "A", dock_count: 2, installation_date_id: 2, city: "Lakewood")
    station_b = Station.create(name: "B", dock_count: 2, installation_date_id: 1, city: "Denver")
    station_c = Station.create(name: "C", dock_count: 5, installation_date_id: 3, city: "Littleton")


    visit("/stations/3/edit")
        # save_and_open_page
    fill_in("station[name]", with: "test_station")
    fill_in("station[dock_count]", with: 500)
    fill_in("station[installation_date_id]", with: "1990-04-16")
    fill_in("station[city]", with: "new_city")

    click_button("Submit Changes")
    station = Station.last
    expect(current_path).to eq("/stations/#{station.id}")
    expect(page).to have_content("new_city")
  end
end
