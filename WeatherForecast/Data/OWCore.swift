//
//  OWCore.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/11/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import Foundation

/**
 System of measurement for  weather data.
 For example, You can get a temperature data in celcius when
 you specify unit as "Metric". For more information, Please check out [here](https://openweathermap.org/weather-data) .
 */
enum OWSystemOfMeasurement: String{
    case Standard
    case Metric
    case Imperial
}

enum OWPresentableWeatherDataType: Int{
    case Description
    case Temperature
    case WindSpeed
    case WindDirection
    case ProbabilityOfPrecipitation
    case Humidity
    case Pressure
    case Sunrise
    case Sunset
}

protocol OWWeatherData{
    var systemOfMeasurement: OWSystemOfMeasurement{get set}
    
    mutating func convert(to sysOfMeasurement: OWSystemOfMeasurement)
}

func convertTemperature(from current: OWSystemOfMeasurement, to target: OWSystemOfMeasurement, _ value: Double) -> Double{
    let ABSOLUTE_ZERO_IN_CELSIUS    = -273.15
    let ABSOLUTE_ZERO_IN_FAHRENHEIT = -459.67
    
    switch current {
    case .Standard:
        switch target {
        case .Standard:
            return value
        case .Metric:
            return value + ABSOLUTE_ZERO_IN_CELSIUS
        case .Imperial:
            return (9.0/5.0) * (value + ABSOLUTE_ZERO_IN_CELSIUS) + 32.0
        }
    case .Metric:
        let standard = value - ABSOLUTE_ZERO_IN_CELSIUS
        
        switch target {
        case .Standard:
            return standard
        case .Metric:
            return value
        case .Imperial:
            return (9.0/5.0) * (standard + ABSOLUTE_ZERO_IN_CELSIUS) + 32.0
        }
    case .Imperial:
        let standard = (value - ABSOLUTE_ZERO_IN_FAHRENHEIT) * (5.0/9.0)
        
        switch target {
        case .Standard:
            return standard
        case .Metric:
            return standard + ABSOLUTE_ZERO_IN_CELSIUS
        case .Imperial:
            return value
        }
    }
}

func convertWindSpeed(from current: OWSystemOfMeasurement, to target: OWSystemOfMeasurement, _ value: Double) -> Double{
    let ONE_METER_IN_MILES: Double  = 0.0006213712
    let ONE_HOUR_IN_SECONDS: Double = 3600
    
    switch current {
    case .Standard:
        switch target {
        case .Standard:
            return value
        case .Metric:
            return value
        case .Imperial:
            return value * ONE_METER_IN_MILES * ONE_HOUR_IN_SECONDS
        }
    case .Metric:
        switch target {
        case .Standard:
            return value
        case .Metric:
            return value
        case .Imperial:
            return value * ONE_METER_IN_MILES * ONE_HOUR_IN_SECONDS
        }
    case .Imperial:
        let meterPerSec = value / (ONE_METER_IN_MILES * ONE_HOUR_IN_SECONDS)
        
        switch target {
        case .Standard:
            return meterPerSec
        case .Metric:
            return meterPerSec
        case .Imperial:
            return value
        }
    }
}
