//
//  DailyForecastRefreshButton.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/8/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import SwiftUI

struct DailyForecastRefreshButton: View {
    var startDataDownloading:() -> Void
    var isLabelButton: Bool
    var scaleFactor: CGFloat{
        get{
            if isLabelButton{
                return 1.0
            }else{
                return 0.5
            }
        }
    }
    
    var body: some View {
        Button(action: {self.startDataDownloading()}){
            if isLabelButton{
                Text(LCS_RefreshButton_Caption)
            }else{
                Image("SFSymbolRefresh")
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .scaleEffect(scaleFactor)
    }
}

struct DailyForecastNoDataView: View{
    var startDataDownloading: () -> Void
    
    var body: some View{
        VStack(spacing: 10){
            Text(NoData_RootView_RootView)
            DailyForecastRefreshButton(startDataDownloading: startDataDownloading, isLabelButton: true)
        }
    }
}

