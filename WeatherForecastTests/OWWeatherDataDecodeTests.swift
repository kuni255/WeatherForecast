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

class OWWeatherDataDecodeTests: XCTestCase {
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
                throw OWWeatherDataDecodeTestsError.TestSetupError("Failed to convert a contents of JSON file to byte array")
            }
        }else{
            throw OWWeatherDataDecodeTestsError.TestSetupError("Failed to prepare JSON data")
        }
    }

}
