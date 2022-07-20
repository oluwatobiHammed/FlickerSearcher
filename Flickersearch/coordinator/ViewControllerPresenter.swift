//
//  ViewControllerPresenter.swift
//  GetirTodo
//
//  Created by Oladipupo Oluwatobi on 02/04/2022.
//

import UIKit

@available(iOS 15.0, *)
class ViewControllerPresenter {
    
    
    static let shared = ViewControllerPresenter()
    
    var presentViewControllerObserver: ViewControllerPresentRequest?
    
    fileprivate var requestSubject: ViewControllerPresentRequest? {
        didSet {
            presentViewControllerObserver  = requestSubject 
        }
    }
    fileprivate init() {}
    
    func presentViewController(request: ViewControllerPresentRequest) {
        if let presenter = request.presenter {
            presenter.displayViewController(fromRequest: request)
        }
        else {
            self.requestSubject = request
        }
    }
}

