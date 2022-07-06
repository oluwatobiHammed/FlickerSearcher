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
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView () {
        addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.heightAnchor.constraint(equalToConstant: 200),
            photoImageView.widthAnchor.constraint(equalToConstant: 200),
            bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor)
        ])
    }
    func setUp(data: Data) {
        photoImageView.load(data: data)
    }
}
