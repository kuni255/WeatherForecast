//
//  OWWeatherDataUtils.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/5/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import Foundation
import CoreLocation

let OWAPIHostURL = "https://api.openweathermap.org"
let OWAPIDataEndpointURL = OWAPIHostURL + "/data"
let OWAPIVersion = "2.5"
let OWAPIOneCallAPIEndpointURL = OWAPIDataEndpointURL + "/" + OWAPIVersion + "/onecall"


enum OWWeatherDataHTTPDownloadError: Error{
    case cannotMakeValidURL
    case responseInvalid
    case responseCodeIndicatingFail
    case dataIsNotAvailable
    case dataDecodeFail
    case unexpected
}

struct OWWeatherDataDownloadConfigurations{
    /// Georogical point to obtain forecast data
    var point: CLLocationCoordinate2D
    /**
       Language of frecast data. A server returns description of weather  condition
       in the specified language . (e.g. "en", "ja")
     */
    var langID: String
    /// Unit for forecast data. For more detail, Please refer the comment of UWUnit type
    var systemOfMeasurement: OWSystemOfMeasurement
}

class OWWeatherDataHTTPDownloaderClass{
    var configurations: OWWeatherDataDownloadConfigurations
    var appID: String
    var successfulCompletionHandler: ((OWOneCallWeatherData)->Void)
    var errorHandler: ((URLResponse?, Error)->Void)
    
    /**
     - Description Instantiate Open Weather forecast data downloader
     - Parameter configurations:Configurations will be used for obtaining weather forecast data
     - Parameter appID: REST API token to obtain data from Open Weather.
     - Parameter successfulCompletionHandler: This method will be called when data is downloaded successfully.
     - Parameter errorHandler: This method will be called in the case that failed to obtain forecast data
     */
    init?(_ configurations: OWWeatherDataDownloadConfigurations, appID: String, successfulCompletionHandler: @escaping((OWOneCallWeatherData)->Void), errorHandler: @escaping((URLResponse?, Error)->Void)){
        // parameters
        self.configurations = configurations
        self.appID = appID
        self.successfulCompletionHandler = successfulCompletionHandler
        self.errorHandler = errorHandler
    }
    
    private func makeURL(from configurations: OWWeatherDataDownloadConfigurations) -> URL?{
        var unitsPartIncludesBeforehandAnd: String
        var URLString = OWAPIOneCallAPIEndpointURL
        
        // units part
        switch configurations.systemOfMeasurement {
        case .Imperial:
            unitsPartIncludesBeforehandAnd = "&units=imperial"
        case .Metric:
            unitsPartIncludesBeforehandAnd = "&units=metric"
        case .Standard:
            unitsPartIncludesBeforehandAnd = ""
        }
        
        URLString = URLString + String(format: "?lat=%f&lon=%f&exclude=current,minutely,hourly\(unitsPartIncludesBeforehandAnd)&lang=\(configurations.langID)&appid=\(self.appID)",
            configurations.point.latitude, configurations.point.longitude)
        
        return URL.init(string: URLString)
    }
    
    func ExecuteAsync() throws {
        var APIURL: URL
        
        // Make URL from the initialized properties
        if let _URL = makeURL(from: self.configurations){
            APIURL = _URL
        }else{
            throw OWWeatherDataHTTPDownloadError.cannotMakeValidURL
        }
        
        // Start downloading
        URLSession.shared.dataTask(with: APIURL, completionHandler: HandleURLSession)
        .resume()
    }
    
    private func HandleURLSession(data: Data?, response: URLResponse?, error: Error?)->Void{
        if error == nil{
            if let httpRes = response as? HTTPURLResponse{
                if httpRes.statusCode == 200{
                    if let _data = data{
                        let dataDecoder = JSONDecoder()
                        do{
                            var weatherData = try dataDecoder.decode(OWOneCallWeatherData.self, from: _data)
                            weatherData.systemOfMeasurement = configurations.systemOfMeasurement
                            DispatchQueue.main.sync {
                                successfulCompletionHandler(weatherData)
                            }
                        }catch{
                            let err = OWWeatherDataHTTPDownloadError.dataDecodeFail
                            DispatchQueue.main.sync {
                                errorHandler(response, err)
                            }
                        }
                    }else{
                        let err = OWWeatherDataHTTPDownloadError.dataIsNotAvailable
                        DispatchQueue.main.sync {
                            errorHandler(response, err)
                        }
                    }
                }else{
                    let err = OWWeatherDataHTTPDownloadError.responseCodeIndicatingFail
                    DispatchQueue.main.sync {
                        errorHandler(response, err)
                    }
                }
            }else{
                let err = OWWeatherDataHTTPDownloadError.unexpected
                DispatchQueue.main.sync {
                    errorHandler(response, err)
                }
            }
        }else{
            DispatchQueue.main.sync {
                errorHandler(response, error!)
            }
        }
    }
}
