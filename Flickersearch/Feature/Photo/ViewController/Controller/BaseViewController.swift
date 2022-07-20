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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BaseViewController.displayingViewController = self
        if #available(iOS 15.0, *) {
            guard let request = ViewControllerPresenter.shared.presentViewControllerObserver else {
                return
            }
            self.displayViewController(fromRequest: request)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BaseViewController.displayingViewController = nil
        if self.isMovingFromParent {
            if #available(iOS 15.0, *) {
                self.onRemovingFromParent()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

