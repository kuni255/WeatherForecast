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
    case responseInvalid
    case responseCodeIndicatingFail
    case dataIsNotAvailable
    case dataDecodeFail
    case unexpected
}

class OWWeatherDataHTTPDownloaderClass{
    var point: CLLocationCoordinate2D
    var appID: String
    var successfulCompletionHandler: ((OWOneCallWeatherData)->Void)
    var errorHandler: ((URLResponse?, Error)->Void)
    let APIURL: URL
    
    /**
     - Description Instantiate Open Weather forecast data downloader
     - Parameter point: Georogical point to obtain forecast data
     - Parameter langID: Language of frecast data. A server returns description of weather  condition
                        in the specified language . (e.g. "en", "ja")
     - Parameter appID: REST API token to obtain data from Open Weather.
     - Parameter successfulCompletionHandler: This method will be called when data is downloaded successfully.
     - Parameter errorHandler: This method will be called in the case that failed to obtain forecast data
     */
    init?( point: CLLocationCoordinate2D, langID: String, appID: String, successfulCompletionHandler: @escaping((OWOneCallWeatherData)->Void), errorHandler: @escaping((URLResponse?, Error)->Void)){
        self.point = point
        self.appID = appID
        self.successfulCompletionHandler = successfulCompletionHandler
        self.errorHandler = errorHandler
        
        var URLString = OWAPIOneCallAPIEndpointURL
        URLString = URLString + String(format: "?lat=%f&lon=%f&exclude=current,minutely,hourly&units=metric&lang=\(langID)&appid=",
                               point.latitude, point.longitude) + self.appID
        if let _APIURL = URL.init(string: URLString){
            APIURL = _APIURL
        }else{
            return nil
        }
    }
    
    func ExecuteAsync(){
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
                            let weatherData = try dataDecoder.decode(OWOneCallWeatherData.self, from: _data)
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
