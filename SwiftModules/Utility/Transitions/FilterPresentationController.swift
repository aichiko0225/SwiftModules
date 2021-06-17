//
//  FilterPresentationController.swift
//  FilterModule
//
//  Created by ash on 2020/2/19.
//

import UIKit

@available(iOS 9.0, *)
open class FilterPresentationController: UIPresentationController {

    var closeBlock: (() -> Void)?
    
    private var dismissingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.25)
        return view
    }()
    
    open override func presentationTransitionWillBegin() {
        dismissingView.frame = containerView?.frame ?? UIScreen.main.bounds
        containerView?.addSubview(dismissingView)
        containerView?.addSubview(presentedViewController.view)
        let r = presentedViewController.transitionCoordinator
        dismissingView.alpha = 0
        r?.animate(alongsideTransition: { (_) in
            self.dismissingView.alpha = 1
        }, completion: nil)
    }
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dismissingView.removeFromSuperview()
        }
       
        if let filterVC = presentedViewController as? UIViewController {
            // 如果为FilterViewController，则加上点击方法，点击可以返回
            if let ttt = filterVC as? TransitionCloseEvent {
                dismissingView.addGestureRecognizer(UITapGestureRecognizer.init(target: filterVC, action: #selector(ttt.cc_closeAction)))
            }
        }
    }
    
    open override func dismissalTransitionWillBegin() {
        let r = presentingViewController.transitionCoordinator
        r?.animate(alongsideTransition: { (_) in
            self.dismissingView.alpha = 0
        }, completion: nil)
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            closeBlock?()
            dismissingView.removeFromSuperview()
        }
    }
}

@objc public protocol TransitionCloseEvent: AnyObject {
    @objc func cc_closeAction()
}

extension UIViewController: TransitionCloseEvent {
    public func cc_closeAction() {
        let filterTransition = FilterTransition(mode: TransitionConfig.transitionMode)
        transitioningDelegate = filterTransition
        modalPresentationStyle = .custom
        dismiss(animated: true, completion: nil)
    }
}

extension TransitionCloseEvent where Self: UIViewController {
    
    public func cc_closeAction() {
        let filterTransition = FilterTransition(mode: TransitionConfig.transitionMode)
        transitioningDelegate = filterTransition
        modalPresentationStyle = .custom
        dismiss(animated: true, completion: nil)
    }
    
}
