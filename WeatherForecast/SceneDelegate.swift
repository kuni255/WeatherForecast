//
//  SceneDelegate.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 7/29/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData
import CoreLocation
import os

enum LoadCustomPropertiesError: Error{
    case FailedToLoadTargetPointLatitude
    case FailedToLoadTargetPointLongitude
    case FailedToLoadOpenWeatherAppID
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootViewDelegate: DailyForecastListWrapViewDelegate?
    
    var targetPoint: CLLocationCoordinate2D?
    var locations: [WFWeatherForecastLocation]
    var openWeatherAppID: String?
    
    override init(){
        locations = []
        super.init()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Read properties from Info.plist
        do{
            try loadProperties()
        }catch{
            os_log("Failed to load app specific properties", log: .default, type: .error)
            return
        }
        
        // Register my self as a observer of prefereces change
        UserDefaults.standard.addObserver(self, forKeyPath: "measurementSystem_preference", options: [NSKeyValueObservingOptions.new], context: nil)

        // Create the SwiftUI view that provides the window contents.
        if (targetPoint != nil) && (openWeatherAppID != nil){
            if let delegate = DailyForecastListWrapViewDelegate.init(point: targetPoint!, openWeatherAppID: openWeatherAppID!){
                rootViewDelegate = delegate
                let contentView = DailyForecastListWrapView.init(delegate: rootViewDelegate!)
                
                // Use a UIHostingController as window root view controller.
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = UIHostingController(rootView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                    
                    rootViewDelegate!.startDataDownloading()
                }
            }else{
                os_log(.error, log: .default, "Failed to setup initial view")
                return
            }
        }else{
            os_log(.error, log: .default, "Required properties is not available")
            return
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        UserDefaults.standard.removeObserver(self, forKeyPath: "measurementSystem_preference", context: nil)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func loadProperties()throws{
        // Load target point
        if let latiude = Bundle.main.object(forInfoDictionaryKey: "TargetPointLatitude") as? Double{
            if let longitude = Bundle.main.object(forInfoDictionaryKey: "TargetPointLongitude") as? Double{
                let lat = CLLocationDegrees.init(exactly: latiude)
                if lat == nil{
                    throw LoadCustomPropertiesError.FailedToLoadTargetPointLatitude
                }
                let lon = CLLocationDegrees.init(exactly: longitude)
                if lon == nil{
                    throw LoadCustomPropertiesError.FailedToLoadTargetPointLongitude
                }
                
                targetPoint = CLLocationCoordinate2D.init(latitude: lat!, longitude: lon!)
            }else{
                throw LoadCustomPropertiesError.FailedToLoadTargetPointLongitude
            }
        }else{
            throw LoadCustomPropertiesError.FailedToLoadTargetPointLatitude
        }
        
        // Load Open Weather App ID
        if let _appID = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAppID") as? String{
            openWeatherAppID = _appID
        }else{
            throw LoadCustomPropertiesError.FailedToLoadOpenWeatherAppID
        }
    }
    
    // Observe defaults change
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let _keyPath = keyPath{
            if _keyPath == "measurementSystem_preference"{
                if let _change = change{
                    let newStrValue = _change[NSKeyValueChangeKey.newKey] as! String
                    if let newSysMeasure = OWSystemOfMeasurement.init(rawValue: newStrValue){
                        if let delegate = rootViewDelegate{
                            delegate.handleChangeOfMeasurementSystem(newSystem: newSysMeasure)
                        }
                    }else{
                        os_log(.error, log: .default, "Failed to extract new value from preference system")
                    }
                }else{
                    os_log(.error, log: .default, "Failed to extract new value from preference system")
                }
            }else{
                return
            }
        }else{
            return
        }
    }
    
    // User data
    func load()->WFUserData?{
        var userData: WFUserData
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        do{
            let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
            if let userDataList = try container.viewContext.fetch(request) as? [WFUserData]{
                guard userDataList.count > 0 else{
                    os_log(.info, log: .default, "No stored user data")
                    
                    save()
                    return nil
                }
                
                userData = userDataList[0]
                let locArray = userData.locations?.allObjects as! [WFWeatherForecastUserLocation]
                
                for location in locArray{
                    print(location.caption!)
                }
                
                return userData
            }else{
                os_log(.error, log: .default, "Failed to fetch user data")
                return nil
            }
        }catch{
            os_log(.error, log: .default, "Failed to load user data")
            return nil
        }
    }
    
    func save(){
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let userData = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: container.viewContext) as? WFUserData
        guard userData != nil else{
            os_log(.error, log: .default, "Failed to save data")
            return
        }
        let location = NSEntityDescription.insertNewObject(forEntityName: "PreferredLocation", into: container.viewContext) as? WFWeatherForecastUserLocation
        guard location != nil else{
            os_log(.error, log: .default, "Failed to save data")
            return
        }
        
        location!.caption = "Oita"
        location!.id = UUID()
        location!.latitude = 33.238194
        location!.longitude = 131.612667
        
        userData!.addToLocations(location!)
        
        userData!.defaultLocation = location?.id
    }
}

