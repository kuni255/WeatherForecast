//
//  DailyForecastDetailView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/2/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

struct DailyForecastDetailView: View {
    var forecastData: OWDailyForecastWeatherData
    
    var date: String{
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d (EEE)"
        return formatter.string(from: forecastData.time)
    }
    
    var body: some View {
        VStack{
            // Header
            HStack{
                Text(date)
                    .font(.largeTitle)
                OWWeatherConditionIcon(size: 90.0, iconID: forecastData.weatherList[0].iconID)
            }
            // Body
            DailyForecastDetailBodyView(forecastData: forecastData)
            Spacer()
        }
    }
}

struct DailyForecastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastDetailView(forecastData: sampleData.dailyForecaastData[0])
    }
}
