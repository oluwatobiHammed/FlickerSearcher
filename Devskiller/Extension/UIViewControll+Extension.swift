//
//  UIViewControll+Extension.swift
//  GetirTodo
//
//  Created by Oladipupo Oluwatobi on 02/04/2022.
//

import UIKit


typealias EmptyCallback = () -> Void

enum ViewControllerPresentationMode {
    case present
    case presentForce
    case modal
    case addToParent
    case root
}

enum SlideDirection {
    case left
    case right
    case top
    case bottom
}

protocol OverlayViewController {
    var navigationBarIsHidden: Bool { get set }
}

class ViewControllerPresentRequest {
    var mode: ViewControllerPresentationMode
    var viewController: UIViewController
    var presenter: UIViewController?
    var requestData: Any?
    var didPresent: Bool = false
    var didRemove: Any?
    fileprivate var didPresentSubject: Bool = false  {
        didSet {
            didPresent = didPresentSubject
        }
    }
    fileprivate var didRemoveSubject: Any? {
        didSet {
            didRemove = didPresentSubject
        }
    }
    
    init(mode: ViewControllerPresentationMode, viewController: UIViewController) {
        self.mode = mode
        self.viewController = viewController
    }
    
    deinit {
        print("Destroying ViewControllerPresentRequest")
    }
    
}

protocol ViewControllerPresentedDidDisappear {
    var viewControllerWillDisappearData: Any? {get set}
    var didRemoveViewControllerSubject: Any? {get set}
}

protocol ViewControllerPresentRequestDataReceiver {
    var presentRequestData: Any? {get set}
}

@available(iOS 15.0, *)
extension UIViewController {
    
    func add(child: UIViewController, container: UIView, configure: (_ childView: UIView) -> Void = { _ in }) {
        addChild(child)
        container.addSubview(child.view)
        configure(child.view)
        child.didMove(toParent: self)
    }
    
    func getNavigationViewController()-> UINavigationController? {
        if let navController = self.parent as? UINavigationController {
            return navController
        }
        return nil
    }
    
    func displayViewController(fromRequest: ViewControllerPresentRequest) {
        
        if var disappearSubject = fromRequest.viewController as? ViewControllerPresentedDidDisappear {
            disappearSubject.didRemoveViewControllerSubject = fromRequest.didRemoveSubject
        }
        
        if var requestSetter = fromRequest.viewController as? ViewControllerPresentRequestDataReceiver {
            requestSetter.presentRequestData = fromRequest.requestData
        }
        switch fromRequest.mode {
        case .modal:
            fromRequest.viewController.modalPresentationStyle = .overCurrentContext
            self.present(fromRequest.viewController, animated: true) {
                fromRequest.didPresentSubject = true
            }
            
        case .presentForce:
            self.present(fromRequest.viewController, animated: true){
                fromRequest.didPresentSubject = true
            }
            
        case .present:
            if let navController = self.navigationController {
                navController.pushViewControllerFromRight(controller: fromRequest.viewController)
                fromRequest.didPresentSubject = true
            }
            
            else {
                self.present(fromRequest.viewController, animated: true) {
                    fromRequest.didPresentSubject = true
                }
            }
            
        case .root:
            let _ = StoryBoardsID.makeAsRoot(using: fromRequest.viewController)
            fromRequest.didPresentSubject = true
        case .addToParent:
            self.addToParent(fromRequest.viewController)
            fromRequest.didPresentSubject = true
        }
    }
    
    func addToParent(_ child: UIViewController, slideFrom: SlideDirection? = nil, duration: TimeInterval = 0.5, completion: EmptyCallback? = nil) {
        
        var navigationBar: UINavigationBar? = nil
        if var buttonSheetController = child as? OverlayViewController {
            if let navControl = self.getNavigationViewController() {
                navigationBar = navControl.navigationBar
                buttonSheetController.navigationBarIsHidden = true
            }
        }
        
        let childView = child.view
        
        if let slideFrom = slideFrom {
            switch slideFrom {
            case .top:
                childView?.frame.origin.y = 0.0 - self.view.frame.height
            case .bottom:
                childView?.frame.origin.y = self.view.frame.height
            case .left:
                childView?.frame.origin.x = 0.0 - self.view.frame.width
            case .right:
                childView?.frame.origin.x = self.view.frame.width
            }
        }
        else {
            childView?.alpha = 0
        }
        
        addChild(child)
        self.view.addSubview(child.view)
        
        
        UIView.animate(withDuration: duration, animations: {
            if let slideFrom = slideFrom {
                switch slideFrom {
                case .top:
                    childView?.frame.origin.y = 0
                case .bottom:
                    childView?.frame.origin.y = 0
                case .left:
                    childView?.frame.origin.x = 0
                case .right:
                    childView?.frame.origin.x = 0
                }
            }
            
            else {
                childView?.alpha = 1
            }
            
        }){ (completed: Bool) in
            child.didMove(toParent: self)
            if let completion = completion {
                completion()
            }
        }
        
        UIView.animate(withDuration: duration + 0.3, animations: {
        }) {
            (completed: Bool) in
            if completed {
                if let navBar = navigationBar {
                    navBar.isHidden = true
                }
            }
        }
        
    }
    
    func onRemovingFromParent() {
        if var invoker = self as? ViewControllerPresentedDidDisappear {
            invoker.didRemoveViewControllerSubject = invoker.viewControllerWillDisappearData
            invoker.didRemoveViewControllerSubject = nil
        }
    }
}



extension UINavigationController {
    func popViewControllerItem(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func pushViewControllerFromRight(controller: UIViewController)  {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
}
