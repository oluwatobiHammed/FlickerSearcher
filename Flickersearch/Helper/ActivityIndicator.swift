//
//  ActivityIndicator.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 21/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import UIKit

class ActivityIndicator: NSObject {
    
    static var shared = ActivityIndicator()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    func start(view:UIView) {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
    }

    func stop() {
        activityIndicator.removeFromSuperview()
    }

}

