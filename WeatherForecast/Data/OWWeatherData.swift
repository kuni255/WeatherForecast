//
//  OWForecastData.swift
//  ListViewTry
//
//  Created by Kuniie Hayato on 7/29/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//
/*
 Data types represents weather data by OpenWeather ( https://openweathermap.org )
 In detail, You can get the following data by calling One Call API ( https://openweathermap.org/api/one-call-api )
 */
import CoreLocation
import Foundation
import os

struct OWDailyForecastWeatherFeelsLikeData: Codable{
    var morning: Double
    var day: Double
    var evening: Double
    var night: Double
    
    enum CodingKeys: String, CodingKey{
        case morning = "morn"
        case day
        case evening = "eve"
        case night
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        morning = try container.decode(Double.self, forKey: .morning)
        day = try container.decode(Double.self, forKey: .day)
        evening = try container.decode(Double.self, forKey: .evening)
        night = try container.decode(Double.self, forKey: .night)
    }
    
    func encode(to encoder: Encoder)throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(morning, forKey: .morning)
        try container.encode(day, forKey: .day)
        try container.encode(evening, forKey: .evening)
        try container.encode(night, forKey: .night)
    }
}

struct OWDailyForecastWeahterTemperatureData: Codable{
    var morning: Double
    var day: Double
    var evening: Double
    var night: Double
    var min: Double
    var max: Double
    
    enum CodingKeys: String, CodingKey{
        case morning = "morn"
        case day
        case evening = "eve"
        case night
        case min
        case max
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        morning = try container.decode(Double.self, forKey: .morning)
        day = try container.decode(Double.self, forKey: .day)
        evening = try container.decode(Double.self, forKey: .evening)
        night = try container.decode(Double.self, forKey: .night)
        min = try container.decode(Double.self, forKey: .min)
        max = try container.decode(Double.self, forKey: .max)
    }
    
    func encode(to encoder: Encoder)throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(morning, forKey: .morning)
        try container.encode(day, forKey: .day)
        try container.encode(evening, forKey: .evening)
        try container.encode(night, forKey: .night)
        try container.encode(min, forKey: .min)
        try container.encode(max, forKey: .max)
    }
}

struct OWDailyForecastWeatherConditionData: Codable{
    var id: Int
    var main: String
    var description: String
    var iconID: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case main
        case description
        case iconID = "icon"
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        main = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        iconID = try container.decode(String.self, forKey: .iconID)
    }
    
    func encode(to encoder: Encoder)throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(main, forKey: .main)
        try container.encode(description, forKey: .description)
        try container.encode(iconID, forKey: .iconID)
    }
}

struct OWDailyForecastWeatherData: Codable, Identifiable{
    var time: Date!
    var sunriseTime: Date!
    var sunsetTime: Date!
    var temperature: OWDailyForecastWeahterTemperatureData!
    var feelsLike: OWDailyForecastWeatherFeelsLikeData!
    var pressure: Int
    var humidity: Int
    var dewPoint: Double
    var windSpeed: Double
    var windGust: Double?
    var windDirection: Int
    var weatherList: [OWDailyForecastWeatherConditionData]
    var cloudiness: Int
    var UVIndex: Double
    var visibility: Int?
    var probabilityOfPrecipitation: Double
    var rainVolume: Int?
    var snowVolume: Int?
    
    //MARK: Identifiable
    var id: Date{
        return time
    }
    
    enum CodingKeys: String, CodingKey{
        case time = "dt"
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDirection = "wind_deg"
        case weatherList = "weather"
        case cloudiness = "clouds"
        case UVIndex = "uvi"
        case visibility
        case probabilityOfPrecipication = "pop"
        case rainVolume = "rain"
        case snowVolume = "snow"
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var UNIXTime = try container.decode(TimeInterval.self, forKey: .time)
        time = Date.init(timeIntervalSince1970: UNIXTime)
        UNIXTime = try container.decode(TimeInterval.self, forKey: .sunriseTime)
        sunriseTime = Date.init(timeIntervalSince1970: UNIXTime)
        UNIXTime = try container.decode(TimeInterval.self, forKey: .sunsetTime)
        sunsetTime = Date.init(timeIntervalSince1970: UNIXTime)
        temperature = try container.decode(OWDailyForecastWeahterTemperatureData.self, forKey: .temperature)
        feelsLike = try container.decode(OWDailyForecastWeatherFeelsLikeData.self, forKey: .feelsLike)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        dewPoint = try container.decode(Double.self, forKey: .dewPoint)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        do{
            windGust = try container.decode(Double.self, forKey: .windGust)
        }catch{
            windGust = nil
        }
        windDirection = try container.decode(Int.self, forKey: .windDirection)
        // Decode weather list
        var weatherListContainer = try container.nestedUnkeyedContainer(forKey: .weatherList)
        var weatherCondition: OWDailyForecastWeatherConditionData
        weatherList = []
        while !weatherListContainer.isAtEnd{
            weatherCondition = try weatherListContainer.decode(OWDailyForecastWeatherConditionData.self)
            weatherList.append(weatherCondition)
        }
        
        cloudiness = try container.decode(Int.self, forKey: .cloudiness)
        UVIndex = try container.decode(Double.self, forKey: .UVIndex)
        do{
            visibility = try container.decode(Int.self, forKey: .visibility)
        }catch{
            visibility = nil
        }
        probabilityOfPrecipitation = try container.decode(Double.self, forKey: .probabilityOfPrecipication)
        do{
            rainVolume = try container.decode(Int.self, forKey: .rainVolume)
        }catch{
            rainVolume = nil
        }
        do{
            snowVolume = try container.decode(Int.self, forKey: .snowVolume)
        }catch{
            snowVolume = nil
        }
    }
    
    func encode(to encoder: Encoder)throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(time.timeIntervalSince1970, forKey: .time)
        try container.encode(sunriseTime.timeIntervalSince1970, forKey: .sunriseTime)
        try container.encode(sunsetTime.timeIntervalSince1970, forKey: .sunriseTime)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(feelsLike, forKey: .feelsLike)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(dewPoint, forKey: .dewPoint)
        try container.encode(windSpeed, forKey: .windSpeed)
        if let tmp = windGust{
            try container.encode(tmp, forKey: .windGust)
        }
        try container.encode(windDirection, forKey: .windDirection)
        
        // Encode wather list
        for weatherCondition in weatherList{
            try weatherCondition.encode(to: encoder)
        }
        
        try container.encode(cloudiness, forKey: .cloudiness)
        try container.encode(UVIndex, forKey: .UVIndex)
        if let tmp = visibility{
            try container.encode(tmp, forKey: .visibility)
        }
        try container.encode(probabilityOfPrecipitation, forKey: .probabilityOfPrecipication)
        if let tmp = rainVolume{
            try container.encode(tmp, forKey: .rainVolume)
        }
        if let tmp = snowVolume{
            try container.encode(tmp, forKey: .snowVolume)
        }
    }
}

struct OWOneCallWeatherData : Codable{
    var point: CLLocationCoordinate2D!
    var timezone: TimeZone!
    var timezoneCaption: String
    var dailyForecaastData: [OWDailyForecastWeatherData]
    
    enum CodingKeys : String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
        case timezone
        case timezoneOffset = "timezone_offset"
        case dailyForecastData = "daily"
    }
    
    init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        point = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        let timeOffsetSeconds = try container.decode(Int.self, forKey: .timezoneOffset)
        timezoneCaption = try container.decode(String.self, forKey: .timezone)
        if let tmp = TimeZone.init(secondsFromGMT: timeOffsetSeconds){
            timezone = tmp
        }else{
            os_log(.error, "Failed to decode timezone")
        }
        
        // Decode forecast data
        var forecastData: OWDailyForecastWeatherData
        var forecastDataContainer = try container.nestedUnkeyedContainer(forKey: .dailyForecastData)
        dailyForecaastData = []
        while !forecastDataContainer.isAtEnd{
            forecastData = try forecastDataContainer.decode(OWDailyForecastWeatherData.self)
            dailyForecaastData.append(forecastData)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        //TODO: Rewrite here too
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(point.longitude, forKey: .longitude)
        try container.encode(point.latitude, forKey: .latitude)
        try container.encode(timezoneCaption, forKey: .timezone)
        try container.encode(timezone.secondsFromGMT(), forKey: .timezoneOffset)
        
        // Encode forecast data
        for forecastData in dailyForecaastData{
            try container.encode(forecastData, forKey: .dailyForecastData)
        }
    }
}
