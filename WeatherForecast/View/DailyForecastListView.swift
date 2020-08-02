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
        List(sampleData.dailyForecaastData){ forecastData in
            DailyForecastRowView(forecastData: forecastData, weatherIcon: sampleIcon)
        }
    }
}

struct DailyForecastListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastListView()
    }
}
