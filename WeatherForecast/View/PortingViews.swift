//
//  PortingViews.swift
//  WeatherForecast
//
//  Created by Kuniie Hayato on 8/11/20.
//  Copyright © 2020 Kuniie Hayato. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct SUIActivityIndicatorView: UIViewRepresentable{
    @Binding var animating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if animating{
            uiView.startAnimating()
        }else{
            uiView.stopAnimating()
        }
    }
}
