//
//  UsersPreferedLocationsView.swift
//  Weather Forecast
//
//  Created by Kuniie Hayato on 8/24/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//
import MapKit
import SwiftUI
import UIKit

struct UsersPreferredLocationsView: UIViewRepresentable{
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView.init()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Nothing to do
    }
    
    class Coordinator: NSObject{
        var control: UsersPreferredLocationsView
        
        init(_ control: UsersPreferredLocationsView){
            self.control = control
        }
    }
}
