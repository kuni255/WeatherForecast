//
//  DailyForecastDetailBodyView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/2/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

struct DailyForecastDetailBodyView: View {
    var forecastData: OWDailyForecastWeatherData
    
    var body: some View {
        List{
            // Description
            HStack{
                Text(LCS_WeatherDescription_DetailView+":")
                Text(forecastData.weatherList[0].description)
            }
            // Probability of precipitation
            HStack{
                Text(LCS_ProbabilityOfPrecipitation_DetailView+":")
                Text(String(format: "%.0f", forecastData.probabilityOfPrecipitation*100))
            }
            // Max temperature
            HStack{
                Text(LCS_MaxTemp_DetailView+":")
                Text(String(format: "%.1f", forecastData.temperature.max))
            }
            // Min temperature
            HStack{
                Text(LCS_MinTemp_DetailView+":")
                Text(String(format: "%.1f", forecastData.temperature.min))
            }
            // Wind speed
            HStack{
                Text(LCS_WindSpeed_DetailView+":")
                Text(String(format: "%.1f", forecastData.windSpeed))
            }
            // Wind direction
            HStack{
                Text(LCS_WindDirection_DetailView+":")
                Text(String(format: "%d", forecastData.windDirection))
            }
            // Humidity
            HStack{
                Text(LCS_Humidity_DetailView+":")
                Text(String(format: "%d", forecastData.humidity))
            }
            // Pressure
            HStack{
                Text(LCS_Pressure_DetailView+":")
                Text(String(format: "%d", forecastData.pressure))
            }
            // Sunrise
            HStack{
                Text(LCS_Sunrise_DetailView+":")
                Text(getStringForSuriseSunset(forecastData.sunriseTime))
            }
            // Sunset
            HStack{
                Text(LCS_Sunset_DetailView+":")
                Text(getStringForSuriseSunset(forecastData.sunsetTime))
            }
            
        }
    }
    
    func getStringForSuriseSunset(_ time: Date)->String{
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "H:mm"
        return formatter.string(from: time)
    }
}

struct DailyForecastDetailBodyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastDetailBodyView(forecastData: sampleData.dailyForecaastData[0])
    }
}
