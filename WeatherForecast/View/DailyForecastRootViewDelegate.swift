//
//  DailyForecastRootViewDelegate.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/6/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import Foundation
import Combine
import CoreLocation
import SwiftUI

class DailyForecastRootViewDelegate: ObservableObject{
    @Published var state: DailyForecastRootViewState
    @Published var data: OWOneCallWeatherData?
    
    let point: CLLocationCoordinate2D
    let langID: String
    let openWeatherAppID: String
    var downloader: OWWeatherDataHTTPDownloaderClass?
    
    private var _view: DailyForecastRootView? = nil
    
    init?(point: CLLocationCoordinate2D, openWeatherAppID: String){
        self.state            = .noData
        self.point            = point
        self.langID           = Bundle.main.preferredLocalizations.first ?? "en"
        self.openWeatherAppID = openWeatherAppID
        downloader            = nil
        if let _downloader = OWWeatherDataHTTPDownloaderClass.init(point: self.point, langID: langID, appID: self.openWeatherAppID, successfulCompletionHandler: handleDataArrival, errorHandler: handleDataRetrievalFailure){
            downloader = _downloader
        }else{
            return nil
        }
    }
    
    func startDataDownloading(){
        state = .retrievingData
        downloader!.ExecuteAsync()
    }
    
    func handleDataArrival(data: OWOneCallWeatherData){
        self.data = data
        state = .listingData
    }
    
    func handleDataRetrievalFailure(response: URLResponse?, error: Error){
        state = .noData
    }
}
