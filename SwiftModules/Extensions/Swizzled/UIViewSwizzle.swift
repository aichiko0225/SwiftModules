//
//  UIViewSwizzle.swift
//  SwiftModules
//
//  Created by ash on 2020/8/21.
//

import Foundation
import UIKit

open class Function {
    /// 方法交换
    open class func swizzled() {
        UIViewController.doBadSwizzleStuff()
        UINavigationController.doBadSwizzleStuff()
        UIView.doBadSwizzleStuff()
        UITableViewCell.doBadSwizzleStuff()
        UICollectionViewCell.doBadSwizzleStuff()
//        UIControl.doBadSwizzleControl()
    }
    
    private init() { }
}

/// 方法交换，交换系统已有的方法
///
/// - Parameters:
///   - cls: 交换的类
///   - sels: 交换方法数组，原方法和新方法
public func swizzle<T: NSObject>(_ cls: T.Type, sels: [(Selector, Selector)]) {
    sels.forEach { original, swizzled in
        guard let originalMethod = class_getInstanceMethod(cls, original),
            let swizzledMethod = class_getInstanceMethod(cls, swizzled) else { return }
        
        let didAddViewDidLoadMethod = class_addMethod(
            cls,
            original,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        
        if didAddViewDidLoadMethod {
            class_replaceMethod(
                cls,
                swizzled,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}


// MARK: - UIView

public extension UIView {
    private static var hasSwizzled = false
    
    @objc public class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        swizzle(self, sels:
            [
                (#selector(self.traitCollectionDidChange(_:)),
                 #selector(self.cc_traitCollectionDidChange(_:))),
                
                (#selector(self.layoutSubviews),
                 #selector(self.cc_layoutSubviews)),
                
                (#selector(self.init(frame:)),
                 #selector(self.cc_init(frame:))),
                
                (#selector(self.init(coder:)),
                 #selector(self.cc_init(coder:)))
            ]
        )
    }
    
    @objc open func cc_bindViewModel() {}
    
    @objc open func cc_setupUI() {}
    @objc open func cc_setupEvent() {}
    @objc open func cc_setupLayout() {}
    
    @objc internal func cc_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection) {
        self.cc_traitCollectionDidChange(previousTraitCollection)
        cc_setupLayout()
    }
    
    @objc internal func cc_layoutSubviews() {
        self.cc_layoutSubviews()
        if !hasViewAppeared {
            hasViewAppeared = true
            
            cc_setupLayout()
        }
    }
    
    @objc internal func cc_init(frame: CGRect) -> UIView {
        let view = self.cc_init(frame: frame)
        /// UITableViewCell UICollectionViewCell 有自己单独的初始化方法，不在此处做方法交换
        guard !(self is UITableViewCell || self is UICollectionViewCell) else {
            return view
        }
        cc_setupUI()
        cc_setupEvent()
        
        cc_bindViewModel()
        return view
    }
    
    @objc internal func cc_init(coder: NSCoder) -> UIView {
        let view = self.cc_init(coder: coder)
        /// UITableViewCell UICollectionViewCell 有自己单独的初始化方法，不在此处做方法交换
        guard !(self is UITableViewCell || self is UICollectionViewCell) else {
            return view
        }
        cc_setupUI()
        cc_setupEvent()
        
        cc_bindViewModel()
        return view
    }
}

extension UIView {
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
            return objc_getAssociatedObject(self, &AssociatedKeys.hasViewAppeared)
                as? Bool ?? false
        }
    }
}


// MARK: - UITableViewCell

extension UITableViewCell {
    private static var hasSwizzled = false
    
    @objc public override class func doBadSwizzleStuff() {
        /// 保证先hook父类的方法，不会方法交换错误
        super.doBadSwizzleStuff()
        guard !hasSwizzled else { return }
        hasSwizzled = true
        
        swizzle(self, sels: [
            (#selector(self.init(style:reuseIdentifier:)),
             #selector(self.cc_init(style:reuseIdentifier:))),
            (#selector(self.setSelected(_:animated:)),
             #selector(self.cc_setSelected(_:animated:))),
            (#selector(self.awakeFromNib),
             #selector(self.cc_awakeFromNib))
            ]
        )
    }
    
    @objc open override func cc_setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
    }
    
    @objc internal func cc_init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) -> UITableViewCell {
        let cell = self.cc_init(style: style, reuseIdentifier: restorationIdentifier)
        cc_setupUI()
        cc_setupEvent()
        
        cc_bindViewModel()
        
        return cell
    }
    
    @objc internal func cc_awakeFromNib() {
        let view = self.cc_awakeFromNib()
        cc_setupUI()
        cc_setupEvent()
        
        cc_bindViewModel()
    }
    
    @objc internal func cc_setSelected(_ selected: Bool, animated: Bool) {
        self.cc_setSelected(selected, animated: animated)
    }
    
}

// MARK: - UICollectionCell

extension UICollectionViewCell {
    private static var hasSwizzled = false
    
    @objc public override class func doBadSwizzleStuff() {
        /// 保证先hook父类的方法，不会方法交换错误
        super.doBadSwizzleStuff()
        guard !hasSwizzled else { return }
        hasSwizzled = true
        
        swizzle(self, sels:
            [
                (#selector(self.init(frame:)),
                 #selector(self.cc_collectionCell_init(frame:))),
                (#selector(self.awakeFromNib),
                 #selector(self.cc_awakeFromNib))
            ]
        )
    }
    
    @objc internal func cc_collectionCell_init(frame: CGRect) -> UICollectionViewCell {
        let cell = self.cc_collectionCell_init(frame: frame)
        cc_setupUI()
        cc_setupEvent()
        
        cc_bindViewModel()
        
        return cell
    }
    
    @objc internal func cc_awakeFromNib() {
        let view = self.cc_awakeFromNib()
        cc_setupUI()
        cc_setupEvent()
        
        cc_bindViewModel()
    }
    
}
