//
//  BaseViewController.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 16/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ViewControllerPresentRequestDataReceiver,ViewControllerPresentedDidDisappear {
    var presentRequestData: Any?
    
    var viewControllerWillDisappearData: Any?
    
    var didRemoveViewControllerSubject: Any?
    
    static var displayingViewController: UIViewController?
    
    
    deinit {
        print("Disposing \(self)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // observeAlerts()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BaseViewController.displayingViewController = self
        guard let request = ViewControllerPresenter.shared.presentViewControllerObserver else {
            return
        }
        self.displayViewController(fromRequest: request)
        
        //DynamicViewControllerPathResolver.shared.presentNextViewController()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BaseViewController.displayingViewController = nil
        if self.isMovingFromParent {
            self.onRemovingFromParent()
        }
    }
}

