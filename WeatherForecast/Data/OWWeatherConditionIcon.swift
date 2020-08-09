//
//  OWWeatherConditionIcon.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/9/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//
import Foundation
import SwiftUI

let OWWeatherConditionIconNameSuffix = "WCIcon"
let OWWeatherConditionNAIconName = "NA." + OWWeatherConditionIconNameSuffix

struct OWWeatherConditionIcon: View {
    var size: CGFloat
    var iconID: String
    
    let alignment: Alignment = .leading
    var iconImageName: String{
        get{
            return iconID + "." + OWWeatherConditionIconNameSuffix
        }
    }
    
    var body: some View {
        var view: AnyView
        
        if let img = UIImage(named: iconImageName){
            view = AnyView( Image(uiImage: img)
                .resizable()
                .frame(width: size, height: size, alignment: .leading)
            )
        }else{ // For Unknown icon ID
            view = AnyView( Image(OWWeatherConditionNAIconName)
                .resizable()
                .frame(width: size, height: size, alignment: .leading)
            )
        }
        
        return view
    }
}


