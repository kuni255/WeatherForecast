//
//  DailyForecastRowView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/1/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

struct DailyForecastRowView: View {
    var forecastData: OWDailyForecastWeatherData
    
    var date: String{
        // Day
        let components = Calendar.current.dateComponents([.day], from: forecastData.time)
        let day = String(format: "%2d", components.day ?? 0)
        // Day of week
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "(EEE)"
        let dayOfWeek = formatter.string(from: forecastData.time)
        
        return day + " " + dayOfWeek
    }
    
    var body: some View {
        HStack(spacing: 5){
            Group{
                Text(date)
                    .bold()
                    .font(.headline)
                OWWeatherConditionIcon(size: 50.0, iconID: forecastData.weatherList[0].iconID)
            }
            Group{
                Text(getTemperature(forecastData.temperature.max))
                    .foregroundColor(.red)
                    .font(.title)
                Text("/")
                Text(getTemperature(forecastData.temperature.min))
                    .foregroundColor(.blue)
                    .font(.title)
            }
            Text(getProbabilityOfPrecipitation(forecastData.probabilityOfPrecipitation))
                .font(.title)
        }
            .padding(10)
    }
    
    func getTemperature(_ temp: Double) -> String{
        return String(format: "%.0f", temp)
    }
    
    func getProbabilityOfPrecipitation(_ prop: Double) -> String{
        return String(format: "%3.0f %%", prop*100)
    }
}

struct DailyForecastRowView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastRowView(forecastData: sampleData.dailyForecaastData[0])
    }
}
