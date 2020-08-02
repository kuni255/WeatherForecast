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
    var weatherIcon: UIImage
    
    var date: String{
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d (EEE)"
        return formatter.string(from: forecastData.time)
    }
    
    var _weatherIcon: Image{
        return Image.init(uiImage: weatherIcon)
    }
    
    var body: some View {
        VStack{
            // Header
            HStack{
                Text(date)
                    .font(.largeTitle)
                _weatherIcon
            }
            // Body
            DailyForecastDetailBodyView(forecastData: forecastData)
            Spacer()
        }
    }
}

struct DailyForecastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastDetailView(forecastData: sampleData.dailyForecaastData[0], weatherIcon: sampleIcon)
    }
}
