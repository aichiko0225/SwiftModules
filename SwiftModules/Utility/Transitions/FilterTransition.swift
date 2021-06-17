//
//  FilterTransition.swift
//  FilterModule
//
//  Created by ash on 2020/2/19.
//

import Foundation
import UIKit

public class TransitionConfig: NSObject {
    public static var transitionMode: TransitionMode = .right
}

public enum TransitionMode: Int {
    // 从左到右
    case left = 0
    // 从右到左
    case right
}

/// 筛选动作的动画 FilterTransition
@available(iOS 9.0, *)
public class FilterTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    let left: CGFloat = 90
    
    public var duration: TimeInterval = 0.25
    
    let mode: TransitionMode
    
    public var closeBlock: (() -> Void)?
    
    public init(mode: TransitionMode = .right, closeBlock: (() -> Void)? = nil) {
        self.mode = mode
        self.closeBlock = closeBlock
        if TransitionConfig.transitionMode != mode {
            TransitionConfig.transitionMode = mode
        }
        super.init()
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let vc = FilterPresentationController(presentedViewController: presented, presenting: presenting)
        vc.closeBlock = closeBlock
        return vc
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
        
        if mode == .right {
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
        } else {
            if !being {
                // 转场动画，出现时从屏幕左边滑出
                if let toView = toView {
                    containerView.addSubview(toView)
                }
                let t_left = left
                toView?.frame = CGRect(x: -width, y: 0, width: 0, height: height)
                UIView.animate(withDuration: duration, animations: {
                    toView?.frame = CGRect(x: 0, y: 0, width: width-t_left, height: height)
                }) { (complete) in
                    transitionContext.completeTransition(wasCancelled)
                }
            }else {
                fromView?.frame = CGRect(x: 0, y: 0, width: width-left, height: height)
                
                UIView.animate(withDuration: duration, animations: {
                    fromView?.frame = CGRect(x: -width, y: 0, width: 0, height: height)
                }) { (complete) in
                    transitionContext.completeTransition(wasCancelled)
                }
            }
        }
        
        
    }
}

