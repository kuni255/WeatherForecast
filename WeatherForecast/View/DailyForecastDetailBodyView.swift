//
//  DailyForecastDetailBodyView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/2/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

struct DailyForecastDetailItemView<T>: View{
    var lsID: String
    var format: String
    var value: T
    
    var body: some View{
        HStack{
            Text(NSLocalizedString(lsID, comment: "")+":")
            Text(
                String(format: format, value as! CVarArg)
            )
        }
    }
}

struct DailyForecastDetailBodyView: View {
    var forecastData: OWDailyForecastWeatherData
    
    var body: some View {
        List{
            // Description
            DailyForecastDetailItemView<String>(lsID: "WeatherDescription_DetailView", format: "%s", value: forecastData.weatherList[0].description)
            // Probability of precipitation
            DailyForecastDetailItemView<Double>(lsID: "ProbabilityOfPrecipitation_DetailView", format: "%.0f", value: forecastData.probabilityOfPrecipitation*100)
            // Max temperature
            DailyForecastDetailItemView<Double>(lsID: "MaxTemp_DetailView", format: "%.1f", value: forecastData.temperature.max)
            // Min temperature
            DailyForecastDetailItemView<Double>(lsID: "MinTemp_DetailView", format: "%.1f", value: forecastData.temperature.min)
            // Wind speed
            DailyForecastDetailItemView<Double>(lsID: "WindSpeed_DetailView", format: "%.1f", value: forecastData.windSpeed)
            // Wind direction
            DailyForecastDetailItemView<Int>(lsID: "WindDirection_DetailView", format: "%d", value: forecastData.windDirection)
            // Humidity
            DailyForecastDetailItemView<Int>(lsID: "Humidity_DetailView", format: "%d", value: forecastData.humidity)
            // Pressure
            DailyForecastDetailItemView<Int>(lsID: "Pressure_DetailView", format: "%d", value: forecastData.pressure)
            // Sunrise
            DailyForecastDetailItemView<String>(lsID: "Sunrise_DetailView", format: "%s", value: getStringForSuriseSunset(forecastData.sunriseTime))
            // Sunset
            DailyForecastDetailItemView<String>(lsID: "Sunrise_DetailView", format: "%s", value: getStringForSuriseSunset(forecastData.sunsetTime))
        }
    }
    
    func getStringForSuriseSunset(_ time: Date)->String{
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}

struct DailyForecastDetailBodyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastDetailBodyView(forecastData: sampleData.dailyForecaastData[0])
    }
}
