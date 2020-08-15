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
    var systemOfMeasurement: OWSystemOfMeasurement

    var downloadConfigurations: OWWeatherDataDownloadConfigurations
    let openWeatherAppID: String
    
    private var _view: DailyForecastRootView? = nil
    
    init?(point: CLLocationCoordinate2D, openWeatherAppID: String){
        self.state            = .noData
        let langID: String    = Bundle.main.preferredLocalizations.first ?? "en"
        self.systemOfMeasurement    = .Standard
        self.downloadConfigurations = OWWeatherDataDownloadConfigurations(point: point, langID: langID, systemOfMeasurement: .Standard)
        self.openWeatherAppID = openWeatherAppID
    }
    
    func getSystemOfMeasurement()-> OWSystemOfMeasurement{
        if let strMmSys = UserDefaults.standard.string(forKey: "measurementSystem_preference"){
            if let _mmSystem = OWSystemOfMeasurement(rawValue: strMmSys){
                return _mmSystem
            }else{
                return .Standard
            }
        }else{
            return .Standard
        }
    }
    
    //MARK: Downloading data
    func startDataDownloading(){
        state = .retrievingData
        do{
            if let downloader = makeDownloader(){
                try downloader.ExecuteAsync()
            }else{
                state = .noData
            }
        }catch{
            state = .noData
        }
    }
    
    func handleDataArrival(data: OWOneCallWeatherData){
        self.data = data
        state = .listingData
    }
    
    func handleDataRetrievalFailure(response: URLResponse?, error: Error){
        state = .noData
    }
    
    func makeDownloader()-> OWWeatherDataHTTPDownloaderClass?{
        self.downloadConfigurations.systemOfMeasurement = getSystemOfMeasurement()
        
        return OWWeatherDataHTTPDownloaderClass.init(downloadConfigurations, appID: self.openWeatherAppID, successfulCompletionHandler: handleDataArrival, errorHandler: handleDataRetrievalFailure)
    }
    
    //MARK: Change of measurement system
    func handleChangeOfMeasurementSystem(newSystem: OWSystemOfMeasurement){
        if data != nil{
            data!.convert(to: newSystem)
        }
        
        systemOfMeasurement = newSystem
    }
    
}
