//
//  WeatherIcons.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/1/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import Foundation
import UIKit

let sampleIcon = LoadSampleIcon()

func LoadSampleIcon() -> UIImage{
    if let icon = UIImage.init(named: "NAWeather"){
        return icon
    }else{
        fatalError("Failed to load sample icon")
    }
}
