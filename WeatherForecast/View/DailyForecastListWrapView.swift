//
//  DailyForecastRootView.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/4/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//
import Combine
import CoreLocation
import os
import SwiftUI

enum DailyForecastListWrapViewState{
    case noData
    case retrievingData
    case listingData
}

struct DailyForecastListWrapView: View {
    @ObservedObject var delegate: DailyForecastListWrapViewDelegate
    @State private var forecastListView: DailyForecastListView?
    
    init(delegate: DailyForecastListWrapViewDelegate){
        self.delegate = delegate
        forecastListView = nil
    }
    
    var body: some View {
        var view: AnyView = AnyView(Text("Initial view"))
        switch(delegate.state){
                case .listingData:
                    if delegate.data == nil{
                        view = AnyView(DailyForecastNoDataView(startDataDownloading: delegate.startDataDownloading))
                    }else{
                        if let _data = delegate.data{
                            view =  AnyView(DailyForecastListView(data: _data, startDataDownloading: delegate.startDataDownloading))
                        }else{
                            view = AnyView(DailyForecastNoDataView(startDataDownloading: delegate.startDataDownloading))
                        }
                    }
                case .retrievingData:
                    view = AnyView( DailyForecastRetrievingDataView() )
                case .noData:
                    view = AnyView(DailyForecastNoDataView(startDataDownloading: delegate.startDataDownloading))
            }
        return view
    }
}

