//
//  UIAlertController+ShowAlert.swift
//  DFVehicleSteward
//
//  Created by 王立 on 2018/3/30.
//  Copyright © 2018年 ssi. All rights reserved.
//

import Foundation
import UIKit

public extension UIAlertController {
    
    /// 在指定视图控制器上弹出确定框,执行操作
    static func showAlertWithAction(title:String?=nil,message: String, in viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController(),
                                    confirm: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
        var avc = viewController
        if avc == nil{
            avc = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        }
        avc!.present(alert, animated: true)
    }
    
    /// 在指定视图控制器上弹出确定取消框
    static func showConfirm(title:String?=nil, message: String, in viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController(),
                            confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
        
        var avc = viewController
        if avc == nil{
            avc = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        }
        avc!.present(alert, animated: true)
    }
    
    ///弹出多选项alert
    static func showAlert(title:String?=nil, message: String?=nil, in viewController: UIViewController?=UIApplication.shared.keyWindow?.rootViewController,options:[String],
                          endSelect: @escaping((String)->Void)){
        var avc = viewController
        if avc == nil{
            avc = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for str in options {
            let act = UIAlertAction(title: str, style: .default) { (act) in
                endSelect(str)
            }
            alert.addAction(act)
        }
        avc!.present(alert, animated: true)
    }
    
    
    ///弹出选项卡actionSheet
    static func showActionSheet(title:String?=nil, message: String?=nil, in viewController: UIViewController?=UIApplication.shared.keyWindow?.rootViewController,options:[String],
                                endSelect: @escaping((String)->Void)) {
        var avc = viewController
        if avc == nil{
            avc = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for str in options {
            let act = UIAlertAction(title: str, style: .default) { (act) in
                endSelect(str)
            }
            alert.addAction(act)
        }
        let cancelAct = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAct)
        avc!.present(alert, animated: true)
    }
    
}
