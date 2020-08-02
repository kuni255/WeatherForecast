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
        HStack{
            Text(date)
                .bold()
                .font(.title)
            Spacer()
            _weatherIcon
                .resizable()
                .frame(width: 50, height: 50, alignment: .leading)
            Spacer()
            Text(getTemperature(forecastData.temperature.max))
                .foregroundColor(.red)
                .font(.title)
            Text("/")
            Text(getTemperature(forecastData.temperature.min))
                .foregroundColor(.blue)
                .font(.title)
            Spacer()
            Text(getProbabilityOfPrecipitation(forecastData.probabilityOfPrecipitation))
                .font(.title)
            Spacer()
        }
            .padding(10)
    }
    
    func getTemperature(_ temp: Double) -> String{
        return String(format: "%.0f", temp)
    }
    
    func getProbabilityOfPrecipitation(_ prop: Double) -> String{
        return String(format: "%.0f %%", prop)
    }
}

struct DailyForecastRowView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastRowView(forecastData: sampleData.dailyForecaastData[0], weatherIcon: sampleIcon)
    }
}
