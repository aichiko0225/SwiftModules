//
//  FilterTransition.swift
//  FilterModule
//
//  Created by ash on 2020/2/19.
//

import Foundation
import UIKit

/// 筛选动作的动画 FilterTransition
@available(iOS 9.0, *)
open class FilterTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    let left: CGFloat = 75
    
    let duration: TimeInterval = 0.25
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return FilterPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

@available(iOS 9.0, *)
extension FilterTransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        let being = fromVC?.isBeingDismissed ?? false
        
        var toView = transitionContext.view(forKey: .to)
        var fromView = transitionContext.view(forKey: .from)
        
        if toView == nil {
            toView = toVC?.view
        }
        
        if fromView == nil {
            fromView = fromVC?.view
        }
        
        let width = containerView.frame.width
        let height = containerView.frame.height
        
        let wasCancelled = !transitionContext.transitionWasCancelled
        
        if !being {
            // 转场动画，出现时从屏幕右边滑出
            if let toView = toView {
                containerView.addSubview(toView)
            }
            let t_left = left
            toView?.frame = CGRect(x: width, y: 0, width: 0, height: height)
            UIView.animate(withDuration: duration, animations: {
                toView?.frame = CGRect(x: t_left, y: 0, width: width-t_left, height: height)
            }) { (complete) in
                transitionContext.completeTransition(wasCancelled)
            }
        }else {
            fromView?.frame = CGRect(x: left, y: 0, width: width-left, height: height)
            
            UIView.animate(withDuration: duration, animations: {
                fromView?.frame = CGRect(x: width, y: 0, width: 0, height: height)
            }) { (complete) in
                transitionContext.completeTransition(wasCancelled)
            }
        }
    }
}

