//
//  OWWeatherDataViewUtils.swift
//  Weather Forecast
//
//  Created by Kuniie Hayato on 8/15/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import Foundation

func getUnitCaption(for dataType: OWPresentableWeatherDataType, systemOfMeasurement: OWSystemOfMeasurement)->String{
    switch dataType {
    case .Temperature:
        switch systemOfMeasurement {
        case .Standard:
            return "(K)"
        case .Metric, .Imperial:
            return "(°)"
        }
    case .WindSpeed:
        switch systemOfMeasurement {
        case .Standard, .Metric:
            return "(m/sec)"
        case .Imperial:
            return "(mile/hour)"
        }
    case .WindDirection:
        return "(degree)"
    case .ProbabilityOfPrecipitation:
        return "(%)"
    case .Humidity:
        return "(%)"
    case .Pressure:
        return "(hPa)"
    default:
        return ""
    }
}
