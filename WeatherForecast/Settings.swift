//
//  Settings.swift
//  Weather Forecast
//
//  Created by Kuniie Hayato on 8/12/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import Foundation

/**
   System-preferences system returns nil for a preference -key when the first launch from app installation.
    This is a expected behavior of iOS. Therefore, We need to set appropriate value manually at only the time of first launch.
    This method detects a first launch from a installation by that an instance of UserDefaults return nil for one of app preference.
 */
func setDefaultPreferencesAsNeeded(){
    let thisIsFirstLaunch = UserDefaults.standard.string(forKey: "measurementSystem_preference") == nil
    
    if thisIsFirstLaunch{
        UserDefaults.standard.set("Standard", forKey: "measurementSystem_preference")
    }else{
        return
    }
}
