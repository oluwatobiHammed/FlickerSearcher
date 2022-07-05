//
//  GlobalControllerStoryID.swift
//  GetirTodo
//
//  Created by Oladipupo Oluwatobi on 02/04/2022.
//

import Foundation
import UIKit


@available(iOS 15.0, *)
enum StoryBoardsID: String {
    case boardMain = "Main"
    
    
    func get(for controllerId: UIViewController?)-> UIViewController? {
        return controllerId
    }
    
    func initialController()-> UIViewController? {
        let storyboard = UIStoryboard(name:self.rawValue, bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    func loadAndRoot() {
        if let controller = initialController() {
            let _ = StoryBoardsID.makeAsRoot(using: controller)
        }
    }
    
    func makeAsRoot(using: UIViewController)-> Bool {
        if let controller = self.get(for: using) {
            return StoryBoardsID.makeAsRoot(using: controller)
        }
        return false
    }
    
    static func makeAsRoot(using: UIViewController)-> Bool {
        if let delegate = UIApplication.shared.connectedScenes.first{
            if let sd : SceneDelegate = (delegate.delegate as? SceneDelegate) {
                if let window = sd.window {
                    window.rootViewController = using
                    return true
                }
                return true
            }
        }
        return false
    }
    
    
    
    func navigate(to: UIViewController, from: UIViewController, asRoot: Bool = false, completion: (() -> Swift.Void)? = nil)-> Bool {
        if asRoot {
            return makeAsRoot(using: to)
        }
        else {
            if let to = get(for: to) {
                if let fromNavigation = from.getNavigationViewController() {
                    fromNavigation.pushViewController(to, animated: true)
                }
                else {
                    from.present(to, animated: true, completion: completion)
                }
                return true
            }
        }
        return true
    }
    
    func requestNavigation(to: UIViewController?, requestData: Any?, mode: ViewControllerPresentationMode = .present)-> ViewControllerPresentRequest? {
        return self.requestNavigation(to: to, from: nil, requestData: requestData, mode: mode)
    }
    
    func requestNavigation(to: UIViewController?, from: UIViewController?, requestData: Any?, mode: ViewControllerPresentationMode = .present)-> ViewControllerPresentRequest? {
        if let controller = self.get(for: to) {
            let request = ViewControllerPresentRequest(mode: mode, viewController: controller)
            request.presenter = from
            request.requestData = requestData
            ViewControllerPresenter.shared.presentViewController(request: request)
            return request
        }
        return nil
    }
}
