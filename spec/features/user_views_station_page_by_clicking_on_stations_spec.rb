RSpec.describe "user clicks on stations hyperlink" do
  before do
    zipcode = Zipcode.create(zipcode: "80202")

    trip = Trip.create(duration: 53, start_date_id: 2, end_date_id: 2, start_station_id: 3, end_station_id: 3, bike_id: 3, subscription_type: 'User', zipcode_id: 1)
    trip_2 = Trip.create(duration: 174, start_date_id: 1, end_date_id: 3, start_station_id: 2, end_station_id: 2, bike_id: 1, subscription_type: 'User', zipcode_id: 1)
    trip_3 = Trip.create(duration: 13, start_date_id: 3, end_date_id: 1, start_station_id: 1, end_station_id: 1, bike_id: 2, subscription_type: 'User', zipcode_id: 1)

    date = BikeShareDate.create(date: Date.strptime('1/1/2012', '%m/%d/%Y'))
    date_2 = BikeShareDate.create(date: Date.strptime('2/5/2017', '%m/%d/%Y'))
    date_3 = BikeShareDate.create(date: Date.strptime('2/21/2017', '%m/%d/%Y'))

    station_a = Station.create(name: "A", dock_count: 1, installation_date_id: 1, city: "Chicago")
    station_b = Station.create(name: "B", dock_count: 2, installation_date_id: 2, city: "Denver")
    station_c = Station.create(name: "C", dock_count: 2, installation_date_id: 3, city: "New York")
  end

  it "is rerouted to another page with four squares visible" do
    visit("/")
    click_link("stations")
    expect(page).to have_css("div h2.popup-first")
  end

  it "sees a button with 'view stations'" do
    visit("/")
    click_link("stations")
    expect(page).to_not have_content("h2.popup")
    visible = find("h2#first-block").visible?
    expect(visible).to eq(true)
    expect(page).to have_css("h2.popup", count: 4)
    expect(page).to have_content(:button, "View Stations")
  end

  it "and button changes color when its hovered over" do
    visit("/")
    click_link("stations")
    expect(page).to have_content(:button, "View Stations")
    click_button("View Stations")
  end

  it "can click on View Stations link and see new page" do
    visit("/")
    click_link("stations")
    find_link("View Stations").click
    expect(page).to have_content(:table)
    page.should have_css('nav ul.pagination')
    expect(page).to have_content(:button, "Create New Station")
    expect(page).to have_content(:span)
  end

  it "can click on the BS square top left" do
    visit("/")
    click_link("stations")
    find_link("mother-dash-link").click
    expect(page).to have_content("stations")
    expect(page).to have_content("trips")
    expect(page).to have_content("weather")
  end

  it "can see 'Average Number of Bikes' only when hovering" do
    visit('/')
    click_link("stations")
    h2 = first(:css, ".popup", :visible=> :false)
    expect(page).to_not have_content("Average # Bikes Per Station")
    boolean = h2.matches_css?(".popup-first")
    expect(boolean).to eq(true)
  end

  it "can scroll to see 'Newest' and 'Oldest' Stations" do
    visit('/')
    click_link("stations")
    expect(page).to have_content("Newest Station")
    expect(page).to have_content("Oldest Station")
  end
end
