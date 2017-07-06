RSpec.describe "user sees trips dashboard" do
  before do
    #may need to make the trip instances into @
    @trip_1 = Trip.create(duration: 53, start_date_id: 2, end_date_id: 2, start_station_id: 3, end_station_id: 3, bike_id: 3, subscription_type: 'Subscriber', zipcode_id: 1)
    @trip_2 = Trip.create(duration: 174, start_date_id: 2, end_date_id: 1, start_station_id: 3, end_station_id: 1, bike_id: 1, subscription_type: 'Customer', zipcode_id: 1)
    @trip_3 = Trip.create(duration: 13, start_date_id: 3, end_date_id: 1, start_station_id: 1, end_station_id: 1, bike_id: 2, subscription_type: 'Customer', zipcode_id: 1)

    date_1 = BikeShareDate.create(date: Date.strptime('1/1/2012', '%m/%d/%Y'))
    date_2 = BikeShareDate.create(date: Date.strptime('2/5/2017', '%m/%d/%Y'))
    date_3 = BikeShareDate.create(date: Date.strptime('2/21/2017', '%m/%d/%Y'))

    station_1 = Station.create(name: "Alamo", dock_count: 1, installation_date_id: 1, city: "Chicago")
    station_2 = Station.create(name: "Banks", dock_count: 2, installation_date_id: 2, city: "Denver")
    station_3 = Station.create(name: "Colfax", dock_count: 2, installation_date_id: 3, city: "New York")

    zipcode_1 = Zipcode.create(zipcode: 80202)
    zipcode_2 = Zipcode.create(zipcode: 70202)
    zipcode_3 = Zipcode.create(zipcode: 60202)
    visit("/trips-dashboard")
  end

  it "sees average duration of a ride" do
    # Average duration of a ride method
    expect(page).to have_content((53 + 174 + 13)/3)
    # see how to attach to css class/page location
  end

  it "sees ride with longest duration" do
    # Longest ride method
    expect(page).to have_content(174)
  end

  it "sees ride with shortest duration" do
    # shortest ride method
    expect(page).to have_content(13)
  end

  it "sees the station where most rides start" do
    #Station with the most rides as a starting place.
    expect(page).to have_content("Colfax")
  end

  it "sees the station where most rides end" do
    #Station with the most rides as an ending place.
    expect(page).to have_content("Alamo")
  end

  it "sees Month by Month breakdown of number of rides with subtotals for each year" do
    #
  end

  it "sees which bike has highest ride count" do
    #Most ridden bike with total number of rides for that bike
  end

  it "sees which bike has lowest ride count" do
  #Least ridden bike with total number of rides for that bike
  end

  it "sees user subscriptions by type, count, and percentage" do
  #User subscription type breakout with both count and percentage
    expect(page).to have_content("Customer")
    expect(page).to have_content("Subscriber")
  end

  it "sees the date with most trips count" do
    #Single date with the highest number of trips with a count of those trips.
    expect(page).to have_content(Date.strptime('2/5/2017', '%m/%d/%Y'))
  end

  it "sees which date has the lowest trip count" do
    #Single date with the lowest number of trips with a count of those trips
    expect(page).to have_content(Date.strptime('2/21/2017', '%m/%d/%Y'))
  end
end
