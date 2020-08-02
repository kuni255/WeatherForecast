//
//  DailyForecastListView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/2/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

struct DailyForecastListView: View {
    var body: some View {
        NavigationView{
            List(sampleData.dailyForecaastData){ forecastData in
                NavigationLink(destination: DailyForecastDetailView(forecastData: forecastData, weatherIcon: sampleIcon)){
                    DailyForecastRowView(forecastData: forecastData, weatherIcon: sampleIcon)
                }
            }
        }
            .navigationBarItems(leading: Text("Weather forecast"))
    }
}

struct DailyForecastListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastListView()
    }
}
