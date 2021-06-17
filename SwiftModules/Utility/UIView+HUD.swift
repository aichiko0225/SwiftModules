//
//  UIView+HUD.swift
//  SwiftComponentsDemo
//
//  Created by liangze on 2020/8/7.
//  Copyright © 2020 liangze. All rights reserved.
//

import Foundation
@_exported import MBProgressHUD

let ScreenWidth  = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let StatusBarH   = UIApplication.shared.statusBarFrame.height
let ISIphoneX  = (StatusBarH == 44)
let SafeBottomArea: CGFloat = (ISIphoneX ? 34 : 0)
let TabbarHeight: CGFloat = 49

private var hudKey: Void?
public extension UIView {
    
    enum ToastPosition {
        case center
        case bottom
    }
    ///假定同一时间 一个view上只显示一个 HUD
    var hud: MBProgressHUD? {
        set {
            objc_setAssociatedObject(self, &hudKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &hudKey) as? MBProgressHUD
        }
    }
    
    //显示等待消息
    @discardableResult
    func showText(
        _ title: String?,
        afterDelay delay: TimeInterval = 1.5,
        position: ToastPosition = .center,
        completion: MBProgressHUDCompletionBlock? = nil
    ) -> MBProgressHUD {
        hud?.removeFromSuperview()
        hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud?.mode = .text
        hud?.label.text = title
        hud?.label.font = UIFont.systemFont(ofSize: 16)
        hud?.contentColor = .white
        hud?.bezelView.color = UIColor.init(red: 44/255, green: 46/255, blue: 68/255, alpha: 1).withAlphaComponent(0.78)
        hud?.bezelView.style = .solidColor
        hud?.bezelView.layer.cornerRadius = 8
        hud?.margin = 10
        hud?.minSize = CGSize(width: 150, height: 0)
        hud?.removeFromSuperViewOnHide = true
        hud?.hide(animated: true, afterDelay: delay)
        hud?.completionBlock = completion
        if title.isNilOrEmpty {
            hud?.removeFromSuperview()
        }
        switch position {
        case .center: break
        case .bottom:
            let h = height > 0 ? height : UIScreen.main.bounds.width
            hud?.offset = .init(x: 0, y: h * 0.5 - SafeBottomArea - TabbarHeight - 50)
        }
        return hud!
    }
    
    @discardableResult
    func showLoading(_ title: String? = nil) -> MBProgressHUD {
        hud?.removeFromSuperview()
        hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud?.label.text = title
        hud?.bezelView.color = UIColor.init(red: 44/255, green: 46/255, blue: 68/255, alpha: 1).withAlphaComponent(0.78)
        hud?.bezelView.style = .solidColor
        hud?.contentColor = .white
        hud?.removeFromSuperViewOnHide = true
//        hud?.isUserInteractionEnabled = false
        return hud!
    }
    
    func hiddeLoading() {
        hud?.hide(animated: true)
    }
}

public extension UIViewController {
    
    @discardableResult
    func showText(
        _ title: String?,
        afterDelay delay: TimeInterval = 1.5,
        position: UIView.ToastPosition = .center,
        completion: MBProgressHUDCompletionBlock? = nil
    ) -> MBProgressHUD {
       return view.showText(title, afterDelay: delay, position: position, completion: completion)
    }
    
    @discardableResult
    func showLoading(_ title: String? = nil) -> MBProgressHUD {
        return view.showLoading(title)
    }
    
    func hiddeLoading() {
        view.hud?.hide(animated: true)
    }
}



/* 自定义HUD
//设置遮罩为半透明黑色
hud.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
hud.backgroundView.style = .blur  //模糊的遮罩背景
hud.bezelView.color = UIColor.clear //将提示框背景改成透明
hud.bezelView.layer.cornerRadius = 20.0 //设置提示框圆角
 hud.label.textColor = .orange //标题文字颜色
 hud.label.font = UIFont.systemFont(ofSize: 20) //标题文字字体
 hud.detailsLabel.textColor = .blue //详情文字颜色
 hud.detailsLabel.font = UIFont.systemFont(ofSize: 11) //详情文字字体
 //将菊花设置成橙色
 UIActivityIndicatorView.appearance(whenContainedInInstancesOf:
     [MBProgressHUD.self]).color = .orange
 hud.offset = CGPoint(x:-100, y:-150) //向左偏移100，向上偏移150
 hud.margin = 0 //将各个元素与矩形边框的距离设为0
 hud.minSize = CGSize(width: 250, height: 110)  //设置最小尺寸
 hud.isSquare = true  //正方形提示框
 /// 自定义视图
 hud.mode = .customView //模式设置为自定义视图
 hud.customView = UIImageView(image: UIImage(named: "tick")!) //自定义视图显示图片
*/


    
//    //显示普通消息
//    func showInfo(_ title: String, afterDelay delay: TimeInterval = 0.5) {
//        hud?.removeFromSuperview()
//        hud = MBProgressHUD.showAdded(to: self, animated: true)
//        hud?.mode = .customView //模式设置为自定义视图
//        hud?.customView = UIImageView(image: UIImage(named: "info")!) //自定义视图显示图片
//        hud?.label.text = title
//        hud?.removeFromSuperViewOnHide = true
//        hud?.hide(animated: true, afterDelay: delay)
//    }
        
       //显示成功消息
//       func showSuccess(_ title: String) {
//           let hud = MBProgressHUD.showAdded(to: self, animated: true)
//           hud.mode = .customView //模式设置为自定义视图
//           hud.customView = UIImageView(image: UIImage(named: "tick")!) //自定义视图显示图片
//           hud.label.text = title
//           hud.removeFromSuperViewOnHide = true
//           //HUD窗口显示1秒后自动隐藏
//           hud.hide(animated: true, afterDelay: 1)
//       }
