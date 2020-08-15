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
    var systemOfMeasurement: OWSystemOfMeasurement{
        get{
            return forecastData.systemOfMeasurement
        }
    }
    
    var body: some View {
        List{
            // Description
            HStack{
                Text( getItemStringIncludesDelimiter(dataType: .Description, localizedStringKey: "LSK_WeatherDescription_DetailView") )
                Text(forecastData.weatherList[0].description)
            }
            // Probability of precipitation
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .ProbabilityOfPrecipitation, localizedStringKey: "LSK_ProbabilityOfPrecipitation_DetailView"))
                Text(String(format: "%.0f", forecastData.probabilityOfPrecipitation*100))
            }
            // Max temperature
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .Temperature, localizedStringKey: "LSK_MaxTemp_DetailView"))
                Text(String(format: "%.1f", forecastData.temperature.max))
            }
            // Min temperature
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .Temperature, localizedStringKey: "LSK_MinTemp_DetailView"))
                Text(String(format: "%.1f", forecastData.temperature.min))
            }
            // Wind speed
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .WindSpeed, localizedStringKey: "LSK_WindSpeed_DetailView"))
                Text(String(format: "%.1f", forecastData.windSpeed))
            }
            // Wind direction
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .WindDirection, localizedStringKey: "LSK_WindDirection_DetailView"))
                Text(String(format: "%d", forecastData.windDirection))
            }
            // Humidity
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .Humidity, localizedStringKey: "LSK_Humidity_DetailView"))
                Text(String(format: "%d", forecastData.humidity))
            }
            // Pressure
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .Pressure, localizedStringKey: "LSK_Pressure_DetailView"))
                Text(String(format: "%d", forecastData.pressure))
            }
            // Sunrise
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .Sunrise, localizedStringKey: "LSK_Sunrise_DetailView"))
                Text(getStringForSuriseSunset(forecastData.sunriseTime))
            }
            // Sunset
            HStack{
                Text(getItemStringIncludesDelimiter(dataType: .Sunset, localizedStringKey: "LSK_Sunset_DetailView"))
                Text(getStringForSuriseSunset(forecastData.sunsetTime))
            }
            
        }
    }
    
    //MARK: Item
    let itemValueDelimiter: String = ":"
    func getItemStringIncludesDelimiter(dataType: OWPresentableWeatherDataType, localizedStringKey: String)-> String{
        let unitCaption = getUnitCaption(for: dataType, systemOfMeasurement: systemOfMeasurement)
        return NSLocalizedString(localizedStringKey, comment: "") + " " + unitCaption + itemValueDelimiter
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
