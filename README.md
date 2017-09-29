# Bike Share

## Abstract

In this project we used Ruby, Sinatra, and ActiveRecord to build a site that analyzes bike share usage in San Francisco.

This application collects data in two ways: 1) through web forms allowing users to enter trip/station/weather information, and 2) by consuming CSV files with historical information for stations, trips, and weather. In addition to creating and storing this information for viewing at a later date, this application provides a number of user dashboards with higher level analysis of trends in bike share usage.

The dashboards are populated using Active Record queries and minimal ruby handling. All styling was CSS only.

## Viewing Bike-Share

first clone the repo:
`git clone git@github.com:thedanielvogelsang/bike_share.git`

cd into it:
`cd bike_share`

install bundle:
`gem install bundle`

and bundle install the application gems:
`bundle install`
.....


then drop any existing database, create and migrate:
`rake db:{drop, create, migrate}`

visit the following url to see original download sourcing fro csv data. Currently app is set to populate data with only a small portion of original database.

station csv data:
https://www.kaggle.com/benhamner/sf-bay-area-bike-share/data

to run the app as is, seed the data:
`rake db:seed`

And you're ready to launch! in the console fire up SHOTGUN and visit the BikeShare welcome page:

`(bundle exec) shotgun`

visit: "http://localhost:9393"
