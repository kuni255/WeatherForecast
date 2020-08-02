//
//  OWWeatherDataSample.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/1/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import Foundation

let sampleData: OWOneCallWeatherData = loadSampleData("miyazaki.json")

func loadSampleData(_ filename: String) -> OWOneCallWeatherData{
    var JSONFileContents: String
    
    // Store JSON file contents
    if let JSONFileURL = Bundle.main.path(forResource: filename, ofType: nil){
        do{
            JSONFileContents = try String(contentsOfFile: JSONFileURL, encoding: String.Encoding.utf8)
        }catch{
            fatalError("Failed to load JSON file contents")
        }
    }else{
        fatalError("Failed to get URL of JSON file")
    }
    
    // Encode file content to OWONECallWeatherData
    let decoder =  JSONDecoder()
    if let data = JSONFileContents.data(using: String.Encoding.utf8){
        do{
            let result = try decoder.decode(OWOneCallWeatherData.self, from: data)
            return result
        }catch{
            fatalError("Failed to decode file content to OWOneCallWeatherData")
        }
    }else{
        fatalError("Failed to convert a contents of JSON file to byte array")
    }
}
