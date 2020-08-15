//
//  OWWeatherDataDecodeTests.swift
//  ListViewTryTests
//
//  Created by Kuniie Hayato on 8/1/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import XCTest

enum OWWeatherDataDecodeTestsError: Error{
    case TestSetupError(String)
    case JSONDecodeError
}

enum OWWeatherDataMeasurementSystemTestsError: Error{
    
}

class OWWeatherDataTests: XCTestCase {
    var jsonFileContents: String?
    
    override func setUpWithError() throws {
        // Initialize
        jsonFileContents = nil
        
        if let JSONFileURL = Bundle.main.path(forResource: "miyazaki", ofType: "json"){
            do{
                jsonFileContents = try String(contentsOfFile: JSONFileURL, encoding: String.Encoding.utf8)
            }catch{
                throw OWWeatherDataDecodeTestsError.TestSetupError("Failed to read JSON file")
            }
        }else{
            throw OWWeatherDataDecodeTestsError.TestSetupError("JSON file URL is invalid")
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecode()throws{
        let decoder =  JSONDecoder()
        if let contents = jsonFileContents{
            if let data = contents.data(using: String.Encoding.utf8){
                let result = try decoder.decode(OWOneCallWeatherData.self, from: data)
                print(result.timezoneCaption)
            }else{
                throw OWWeatherDataDecodeTestsError.JSONDecodeError
            }
        }else{
            throw OWWeatherDataDecodeTestsError.TestSetupError("Failed to prepare JSON data")
        }
    }
    
    func testConversionOfMeasurementSystem()throws{
        var convertedValue: Double
        var acceptableError: Double
        
        // Test temperature conversion
        acceptableError = 0.09
        // S -> M
        convertedValue = convertTemperature(from: .Standard, to: .Metric, 0.0)
        XCTAssertEqual(convertedValue, -273.15, accuracy: acceptableError)
        // S -> I
        convertedValue = convertTemperature(from: .Standard, to: .Imperial, 0.0)
        XCTAssertEqual(convertedValue, -459.67, accuracy: acceptableError)
        // M -> S
        convertedValue = convertTemperature(from: .Metric, to: .Standard, 0.0)
        XCTAssertEqual(convertedValue, 273.15, accuracy: acceptableError)
        // M -> I
        convertedValue = convertTemperature(from: .Metric, to: .Imperial, 0.0)
        XCTAssertEqual(convertedValue, 32.0, accuracy: acceptableError)
        // I -> S
        convertedValue = convertTemperature(from: .Imperial, to: .Standard, 0.0)
        XCTAssertEqual(convertedValue, 255.4, accuracy: acceptableError)
        // I -> M
        convertedValue = convertTemperature(from: .Imperial, to: .Metric, 0.0)
        XCTAssertEqual(convertedValue, -17.8, accuracy: acceptableError)
        
        // Test wind speed conversion
        acceptableError = 0.009
        // S -> M
        convertedValue = convertWindSpeed(from: .Standard, to: .Metric, 1.0)
        XCTAssertEqual(convertedValue, 1.0, accuracy: acceptableError)
        // S -> I
        convertedValue = convertWindSpeed(from: .Standard, to: .Imperial, 1.0)
        XCTAssertEqual(convertedValue, 2.24, accuracy: acceptableError)
        // M -> S
        convertedValue = convertWindSpeed(from: .Metric, to: .Standard, 1.0)
        XCTAssertEqual(convertedValue, 1.0, accuracy: acceptableError)
        // M -> I
        convertedValue = convertWindSpeed(from: .Metric, to: .Imperial, 1.0)
        XCTAssertEqual(convertedValue, 2.24, accuracy: acceptableError)
        // I -> S
        convertedValue = convertWindSpeed(from: .Imperial, to: .Standard, 2.24)
        XCTAssertEqual(convertedValue, 1.0, accuracy: acceptableError)
        // I -> M
        convertedValue = convertWindSpeed(from: .Imperial, to: .Metric, 2.24)
        XCTAssertEqual(convertedValue, 1.0, accuracy: acceptableError)
    }

}
