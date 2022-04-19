//
//  ImageViewController.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 16/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import UIKit

class ImageViewController: BaseViewController {

    @IBOutlet weak var largeImageView: UIImageView!
    private var requestData: Data?
    override var presentRequestData: Any? {
        didSet {
            requestData = presentRequestData as? Data
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let data = requestData else {
            return
        }
        
        largeImageView.load(data: data)
    }
    

  

}
