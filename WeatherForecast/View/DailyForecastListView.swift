//
//  DailyForecastListView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/2/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

let sampleListView =  DailyForecastListView(data: sampleData)

struct DailyForecastListView: View {
    @State var data: OWOneCallWeatherData
    
    var body: some View {
        NavigationView{
            List(data.dailyForecaastData){ forecastData in
                NavigationLink(destination: DailyForecastDetailView(forecastData: forecastData, weatherIcon: sampleIcon)){
                    DailyForecastRowView(forecastData: forecastData, weatherIcon: sampleIcon)
                }
            }
                .navigationBarTitle(LCS_Title_ListView)
        }
    }
}

struct DailyForecastListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastListView(data: sampleData)
    }
}
