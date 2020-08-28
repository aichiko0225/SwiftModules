//
//  FilterPresentationController.swift
//  FilterModule
//
//  Created by ash on 2020/2/19.
//

import UIKit

@available(iOS 9.0, *)
open class FilterPresentationController: UIPresentationController {

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
            dismissingView.addGestureRecognizer(UITapGestureRecognizer.init(target: filterVC, action: #selector(UIViewController.cc_closeAction)))
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
            dismissingView.removeFromSuperview()
        }
    }
}

extension UIViewController {
    
    @objc func cc_closeAction() {
        let filterTransition = FilterTransition()
        transitioningDelegate = filterTransition
        modalPresentationStyle = .custom
        dismiss(animated: true, completion: nil)
    }
    
}
