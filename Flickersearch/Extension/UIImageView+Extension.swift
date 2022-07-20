//
//  UIImageView+Extension.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 15/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import UIKit


extension UIImageView: PhotoViewDelegateProtocol {
    func errorHandler(error: String) {
        AlertView.instance.showAlert(title: "Image Error", message: error, alertType: .failure)
    }
    
    func load(data: Data) {
            if let image = UIImage(data: data) {
                self.image = image
            }
    }
}


