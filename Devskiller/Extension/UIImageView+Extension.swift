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


//extension UIImage {
//
//    func resizedImage(with size: CGSize) -> UIImage? {
//        // Create Graphics Context
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//
//        // Draw Image in Graphics Context
//        draw(in: CGRect(origin: .zero, size: size))
//
//        // Create Image from Current Graphics Context
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//
//        // Clean Up Graphics Context
//        UIGraphicsEndImageContext()
//
//        return resizedImage
//    }
    
//}
