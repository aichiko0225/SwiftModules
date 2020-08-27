//
//  UIKit+Extension.swift
//  EmptyAppSwift
//
//  Created by 王立 on 2018/3/27.
//  Copyright © 2018年 Wangli. All rights reserved.
//

import Foundation
import UIKit


// 给视图添加边框
public extension UIView {
    enum GradientColorDirection {
        case leftright
        case topdown
    }
    
    ///添加边框
    func addBorder(borderWidthArray:[Double],color:UIColor) {
        if borderWidthArray.count != 4 {return}
        
        superview?.layoutIfNeeded()
        let sWidth = Double(frame.size.width)
        let sHeight = Double(frame.size.height)
        
        let layerTop = CALayer()
        layerTop.frame = CGRect(x: 0.0, y: 0.0, width: sWidth, height: borderWidthArray[0])
        layerTop.backgroundColor = color.cgColor
        
        let layerLeft = CALayer()
        layerLeft.frame = CGRect(x: 0.0, y: 0.0, width: borderWidthArray[1], height: sHeight)
        layerLeft.backgroundColor = color.cgColor
        
        let layerBottom = CALayer()
        layerBottom.frame = CGRect(x: 0.0, y: sHeight - borderWidthArray[2], width: sWidth, height: borderWidthArray[2])
        layerBottom.backgroundColor = color.cgColor
        
        let layerRight = CALayer()
        layerRight.frame = CGRect(x: sWidth - borderWidthArray[3], y: 0.0, width: borderWidthArray[3], height: sHeight)
        layerRight.backgroundColor = color.cgColor
        
        self.layer.addSublayer(layerTop)
        self.layer.addSublayer(layerLeft)
        self.layer.addSublayer(layerBottom)
        self.layer.addSublayer(layerRight)
    }
    
    ///加渐变色背景
    func addGradientColorLayer(startColor:UIColor,endColor:UIColor,direction:GradientColorDirection){
        let layer = CAGradientLayer()
        layer.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width*VMSize.scale, height: self.bounds.height*VMSize.scale)
        layer.colors = [startColor.cgColor,endColor.cgColor]
        layer.locations = [0,1]
        switch direction {
        case .leftright:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
        case .topdown:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func removeGradientColorLayer(){
        if self.layer.sublayers != nil{
            for layer in self.layer.sublayers! {
                if layer is CAGradientLayer{
                    layer.removeFromSuperlayer()
                    break
                }
            }
        }
    }
    
    ///加消息小圆点,offset以右上角顶点为中心
    func showSmallMessagePoint(pWidth:CGFloat = 5,offset:CGPoint = CGPoint(x: 0, y: 0),color:UIColor = UIColor.red){
        let point = CALayer()
        let width = self.frame.width
        point.frame = CGRect(x: width - (pWidth/2) + offset.x, y: -(pWidth/2) + offset.y, width: pWidth, height: pWidth)
        self.layer.addSublayer(point)
        point.backgroundColor = color.cgColor
        point.cornerRadius = pWidth/2
        point.masksToBounds = true
    }
    
}

// 图片
extension UIImage{
    
    enum GradientColorDirection {
        case leftright
        case topdown
    }
    ///纯色图片
    static func colorImage(_ color:UIColor,_ size:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let con = UIGraphicsGetCurrentContext()
        con?.addRect( CGRect(x: 0, y: 0, width: size.width, height: size.height))
        con?.setFillColor(color.cgColor)
        con?.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    ///两组颜色的渐变色
    static func gradientColorImage(_ startColor:UIColor,_ endColor:UIColor,direction:GradientColorDirection,_ size:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let con = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let sComponents = startColor.cgColor.components ?? [0,0,0,0]
        let eComponents = endColor.cgColor.components ?? [0,0,0,0]
        let components = [sComponents[0],sComponents[1],sComponents[2],sComponents[3],
        eComponents[0],eComponents[1],eComponents[2],eComponents[3]]
        let locations:[CGFloat] = [0.0, 1.0]

        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2)
        guard gradient != nil else {return UIImage()}
        var startPoint = CGPoint(x: 0, y: 0)
        var endPoint = CGPoint(x: size.width, y: 0)
        switch direction {
        case .leftright:
            break
        default:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: size.height)
        }
        con?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

// 输入框
class DFEdgTextField: UITextField {
    @IBInspectable var leftViewPadding : CGFloat = 0.0
    @IBInspectable var rightViewPadding : CGFloat  = 0.0
    @IBInspectable var textLeftPadding : CGFloat  = 0.0
    @IBInspectable var textRightPadding : CGFloat  = 0.0
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += CGFloat(leftViewPadding)
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= CGFloat(rightViewPadding)
        return rect
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        let trect = CGRect(x: rect.origin.x+textLeftPadding, y: rect.origin.y, width: rect.size.width-textLeftPadding-textRightPadding, height: rect.size.height)
        return trect
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        let trect = CGRect(x: rect.origin.x+textLeftPadding, y: rect.origin.y, width: rect.size.width-textLeftPadding-textRightPadding, height: rect.size.height)
        return trect
    }
}

public extension UISearchBar {
    
    func CLW_config(color: UIColor = .white) {
        self.setBackgroundImage(UIImage.colorImage(color, CGSize(width: 1, height: 1)), for: .any, barMetrics: .default)
        self.setBackgroundImage(UIImage.colorImage(color, CGSize(width: 1, height: 1)), for: .any, barMetrics: .defaultPrompt)
        self.setSearchFieldBackgroundImage(UIImage.colorImage(UIColor(white: 0.9, alpha: 1), CGSize(width: 60, height: 28)).resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)), for: .normal)
    }
    
    func config(backColor: UIColor, textBackColor: UIColor) {
        self.setBackgroundImage(UIImage.colorImage(backColor, CGSize(width: 1, height: 1)), for: .any, barMetrics: .default)
        self.setBackgroundImage(UIImage.colorImage(backColor, CGSize(width: 1, height: 1)), for: .any, barMetrics: .defaultPrompt)
        self.setSearchFieldBackgroundImage(UIImage.colorImage(textBackColor, CGSize(width: 60, height: 28)).resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)), for: .normal)
    }
}

