# README

An API for the purpose of retrieving the weather data for a specified number of random locations on the surface of the 
earth.

* Ruby 2.6.1, Rails 5.2.5, and tested under Rspec

* Requires two ENV variables (which are not in the repository):
  * An API key from openweathermap.org, which must be the value of the ENV variable APPID in the application.
  * An access token from mapbox.com, which must be the value of the ENV variable MAPBOX_ACCESS_TOKEN in the application

* Deployment: 
  * Clone from github and deploy locally as a Rails application, according to your OS's instructions.
  * Currently deployed to Heroku, using my credentials, at https://stark-journey-28166.herokuapp.com/dashboard

* N.B. Occasionally a point appears to go missing, and I've expanded the field of view thinking that may do it, but I'm 
not sure where points on boundaries get displayed by Mapbox. 
