//
//  WFUserData.swift
//  Weather Forecast
//
//  Created by Kuniie Hayato on 8/16/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//
import Combine
import CoreLocation
import Foundation
import os

class WFWeatherForecastLocation: NSObject, NSCoding, Identifiable{
    var id: UUID{
        get{
            return _id
        }
    }
    private var _id: UUID
    
    var title: String
    var location: CLLocationCoordinate2D
    
    init(title: String, location: CLLocationCoordinate2D){
        self._id = UUID.init()
        self.title = title
        self.location = location
    }
    
    //MARK: NSCoding
    required init?(coder: NSCoder) {
        // id
        if let idString = coder.decodeObject(forKey: "id") as? String{
            if let id = UUID.init(uuidString: idString){
                self._id = id
            }else{
                os_log(.error, log: .default, "Failed to instantiate WFWeatherForecastLocation from NSCoder")
                return nil
            }
        }else{
            os_log(.error, log: .default, "Failed to instantiate WFWeatherForecastLocation from NSCoder")
            return nil
        }
        // title
        if let title = coder.decodeObject(forKey: "title") as? String{
            self.title = title
        }else{
            os_log(.error, log: .default, "Failed to instantiate WFWeatherForecastLocation from NSCoder")
            return nil
        }
        // location
        let lat = coder.decodeFloat(forKey: "latitude")
        let long = coder.decodeFloat(forKey: "longitude")
        self.location = CLLocationCoordinate2D.init(latitude: Double(lat), longitude: Double(long))
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id.uuidString, forKey: "id")
        coder.encode(self.title, forKey: "title")
        coder.encode(self.location.latitude, forKey: "latitude")
        coder.encode(self.location.longitude, forKey: "longitude")
    }
}

