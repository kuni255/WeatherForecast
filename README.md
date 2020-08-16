#  Private-Purpose SwiftUI app
 This project is only for examining skill for my iOS-app-development. This app display weather forecast data which is offered by OpenWeather ( https://openweathermap.org ). This app can display weather data in **multiple unit systems** (Standard, Metric and Imperial).

![Weather Forecast app](README.files/app.png)

# Technical features
  * Using **SwiftUI** as UI framework
  * App specific setting in Settings.app
  * Support Japanese in UI

# Data source
 Weather forecast data is retrieved by using One Call API ( https://openweathermap.org/api/one-call-api ) by OpenWeather.

 # Build environment
  The following list shows the development environment of this app.
  * OS: macOS Catalina Ver. 10.15.6
  * Xcode: Ver. 11.6
  * Language: Swift
  * UI Framework: SriftUI

# How to build this app
API key for OpenWeather is needed for building this app. You can build this app by the following steps after API key is prepared.
 
  1. Open $Weather Forecast.xcodeproj with Xcode
  2. Open Info.plist
  3. Set your API key for OpenWeather to "OpenWeatherAppID"

![Set API key](README.files/SetAPIKey.png)