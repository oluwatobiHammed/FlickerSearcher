//
//  PhotoCollectionViewCell.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 15/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String {
          return String(describing: self)
      }
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setUp(data: Data) {
        photoImageView.load(data: data)
    }
}
