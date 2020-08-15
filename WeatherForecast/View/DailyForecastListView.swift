//
//  DailyForecastListView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/2/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

struct DailyForecastListView: View {
    var data: OWOneCallWeatherData
    var startDataDownloading: () -> Void
    
    var body: some View {
        NavigationView{
            VStack(spacing: 1.0){
                HStack{
                    Text("LSK_Date_ListView")
                    Text(getTemperatureHeaderTitle(localizationKey: "LSK_MaxTemp_ListView"))
                        .foregroundColor(.red)
                    Text("/")
                    Text(getTemperatureHeaderTitle(localizationKey: "LSK_MinTemp_ListView"))
                        .foregroundColor(.blue)
                    Text("LSK_ProbabilityOfPrecipitation_ListView")
                }
                List(data.dailyForecaastData){ forecastData in
                    NavigationLink(destination: DailyForecastDetailView(forecastData: forecastData)){
                        DailyForecastRowView(forecastData: forecastData)
                    }
                }
            }
            .navigationBarItems(trailing: DailyForecastRefreshButton(startDataDownloading: startDataDownloading, isLabelButton: false))
                .navigationBarTitle( LocalizedStringKey("LSK_Title_ListView") )
        }
    }
    
    func getTemperatureHeaderTitle(localizationKey: String) -> String{
        return NSLocalizedString(localizationKey, comment: "") + " " + getUnitCaption(for: .Temperature, systemOfMeasurement: data.systemOfMeasurement)
    }
}

