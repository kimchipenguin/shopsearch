# Haendlersuche/ChairStore

This is a short iOS application demonstrating the use of Apple Maps API. The app talks with a backend server to get the relevant JSON file either for your location (action: nearby) or for a city provided (action: city). Results are displayed on a map, with additional information provided by the JSON file.

This small project is written in Swift 3 with no dependencies. I coded it in a few hours for a job interview. The task was to write and design (less emphasis on design) an iOS app that talks with a backend server that provided location data via a MySQL database. The database contains longitude and latitude for each store as well as additional information. The app should be able to find stores closest to the iPhone's location.

If you want to compile this app, you'll need to replace <API URL> with the URL of your server. 