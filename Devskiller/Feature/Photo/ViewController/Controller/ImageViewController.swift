//
//  ImageViewController.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 16/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class ImageViewController: BaseViewController {
    
    private var requestData: Data?
    override var presentRequestData: Any? {
        didSet {
            requestData = presentRequestData as? Data
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var largeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setUpView() {
        navigationItem.title = "Image"
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.addSubview(largeImageView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: largeImageView.bottomAnchor, constant: 41),
            largeImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            largeImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            largeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 41)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        guard let data = requestData else {
            return
        }
        largeImageView.load(data: data)
    }
    
    
    
    
}
