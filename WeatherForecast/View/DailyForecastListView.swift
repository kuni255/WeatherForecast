//
//  DailyForecastListView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/2/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

struct DailyForecastListView: View {
    @State var data: OWOneCallWeatherData
    var startDataDownloading: () -> Void
    
    var body: some View {
        NavigationView{
            List(data.dailyForecaastData){ forecastData in
                NavigationLink(destination: DailyForecastDetailView(forecastData: forecastData)){
                    DailyForecastRowView(forecastData: forecastData)
                }
            }
            .navigationBarItems(trailing: DailyForecastRefreshButton(startDataDownloading: startDataDownloading, isLabelButton: false))
                .navigationBarTitle(LCS_Title_ListView)
        }
    }
}

