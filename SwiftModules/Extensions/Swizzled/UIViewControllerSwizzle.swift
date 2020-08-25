//
//  UIViewSwizzle.swift
//  SwiftModules
//
//  Created by ash on 2020/8/21.
//

import Foundation
import UIKit

// MARK: UIViewController
extension UIViewController {
    private static var hasSwizzled = false
    
    /// 交换方法
    @objc public class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        
        swizzle(self, sels:
            [
                (#selector(self.viewDidLoad),
                 #selector(self.cc_viewDidLoad)),
                
                (#selector(self.viewWillAppear(_:)),
                 #selector(self.cc_viewWillAppear(_:))),
                
                (#selector(self.traitCollectionDidChange(_:)),
                 #selector(self.cc_traitCollectionDidChange(_:))),
                
                (#selector(self.performSegue(withIdentifier:sender:)),
                 #selector(self.cc_performSegueWithIdentifier(identifier:sender:)))
            ]
        )
    }
    
    /// 绑定VM
    @objc open func cc_bindViewModel() {}
    /// UI设置
    @objc open func cc_setupUI() {}
    /// UI控件处理事件
    @objc open func cc_setupEvent() {}
    /// UI控件布局
    @objc open func cc_setupLayout() {}
    /// UI导航栏处理
    @objc open func cc_setupNavigationBar() {}
    
    @objc internal func cc_viewDidLoad() {
        self.cc_viewDidLoad()
        cc_setupUI()
        cc_setupEvent()
        
        cc_bindViewModel()
    }
    
    @objc internal func cc_viewWillAppear(_ animated: Bool) {
        self.cc_viewWillAppear(animated)
        
        if !hasViewAppeared {
            hasViewAppeared = true
            
            cc_setupLayout()
            cc_setupNavigationBar()
        }
    }
    
    @objc internal func cc_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.cc_traitCollectionDidChange(previousTraitCollection)
        cc_setupLayout()
    }
    
    @objc internal func cc_init(nibName: String?, bundle: Bundle?) -> UIViewController {
        let controller = self.cc_init(nibName: nibName, bundle: bundle)
        return controller
    }
    
    /// 防止VC多次push
    @objc internal func cc_performSegueWithIdentifier(identifier: String, sender: Any?) {
        if let navigationController = navigationController {
            guard navigationController.topViewController == self else {
                return
            }
        }
        self.cc_performSegueWithIdentifier(identifier: identifier, sender: sender)
    }
}

extension UIViewController {
    private struct AssociatedKeys {
        static var hasViewAppeared = "hasViewAppeared"
    }
    
    /// 是否显示过, 默认为false
    private var hasViewAppeared: Bool {
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.hasViewAppeared,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.hasViewAppeared) as? Bool ?? false
        }
    }
}

// MARK: UINavigationController
extension UINavigationController {
    private static var hasSwizzled = false
    
    @objc public override class func doBadSwizzleStuff() {
        /// 保证先hook父类的方法，不会方法交换错误
        super.doBadSwizzleStuff()
        guard !hasSwizzled else { return }
        hasSwizzled = true
        
        swizzle(self, sels: [
            (#selector(self.pushViewController(_:animated:)),
             #selector(self.cc_pushViewController(_:animated:)))]
        )
    }
    
    /// 替换push方法，自动隐藏tabBar
    @objc func cc_pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 && tabBarController != nil {
            viewController.hidesBottomBarWhenPushed = true
        }
        self.cc_pushViewController(viewController, animated: animated)
    }
}
