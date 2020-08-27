//
//  UIImage+Show.swift
//  VehicleSystem
//
//  Created by aksskas on 2017/4/27.
//  Copyright © 2017年 aksskas. All rights reserved.
//

import UIKit

fileprivate let maxScale: CGFloat = 3.0
fileprivate let minScale: CGFloat = 1.0

fileprivate var totalScale: CGFloat = 1.0

public extension UIImage {

     func showImage(){
        //每次展示图片，需要置为1
        totalScale = 1.0

        //获取根窗口
        let window = UIApplication.shared.keyWindow!
        let bgView = UIView.init(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black

        let imageView = UIImageView.init(frame: UIScreen.main.bounds)

        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        imageView.image = self
        bgView.addSubview(imageView)
        window.addSubview(bgView)

        //点击图片缩小手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideImage))
        bgView.addGestureRecognizer(tap)

        //添加缩放手势
        let sftap = UIPinchGestureRecognizer.init(target: self, action: #selector(sfImage))
        imageView.addGestureRecognizer(sftap)

        //添加平移手势
        let pantap = UIPanGestureRecognizer.init(target: self, action: #selector(panImage))
        imageView.addGestureRecognizer(pantap)
        
    }
    
    //给全屏展示的图片缩放
    func sfAndPanImage(imageView: UIImageView!) {
        //添加缩放手势
        let sftap = UIPinchGestureRecognizer.init(target: self, action: #selector(sfImage))
        imageView.addGestureRecognizer(sftap)
        
        //添加平移手势
        let pantap = UIPanGestureRecognizer.init(target: self, action: #selector(panImage))
        imageView.addGestureRecognizer(pantap)
    }

    @objc private func hideImage(_ tap: UITapGestureRecognizer) {

        let imageView = tap.view?.subviews.first

        UIView.animate(withDuration: 0.5, animations: {
            imageView?.removeFromSuperview()
        }) { (finish) in
            tap.view?.removeFromSuperview()
        }

    }

    //修改锚点
    func adjustAnchorPoint(_ tap: UIPinchGestureRecognizer) {
        if tap.state == .began {
            let piece = tap.view!
            //获得当前手势在view上的位置
            let locationInView = tap.location(in: piece)
            piece.layer.anchorPoint = CGPoint(x: locationInView.x / piece.bounds.size.width, y: locationInView.y / piece.bounds.size.height)

            //设置完锚点后，view的位置发生变化，要将view的位置重新定位到原来的位置
            let locationInSuperView = tap.location(in: piece.superview!)
            piece.center = locationInSuperView

        }
    }

    @objc private func sfImage(_ pinch: UIPinchGestureRecognizer) {

        self.adjustAnchorPoint(pinch)
        let imageView = pinch.view as! UIImageView
        
        if (pinch.scale > 1.0 && totalScale < maxScale) || (pinch.scale < 1.0 && totalScale > minScale) {
          
            imageView.transform = imageView.transform.scaledBy(x: pinch.scale ,   y: pinch.scale)
            
            totalScale *= pinch.scale
            pinch.scale = 1.0
        }
        
        if pinch.state == .ended {
            if totalScale < 1.0 {
                imageView.transform = .identity
                totalScale = 1.0
            }
        }

    }

    @objc private func panImage(_ pan: UIPanGestureRecognizer) {
        let imageView = pan.view as! UIImageView

        if pan.state == .began || pan.state == .changed {
            var position = pan.translation(in: imageView.superview!)

            if position.x > 0 && imageView.frame.minX >= 0 {
                position.x = 0
            }
            if position.x < 0 && imageView.frame.maxX <= VMSize.width {
                position.x = 0
            }

            if position.y > 0 && imageView.frame.minY >= 0 {
                position.y = 0
            }
            if position.y < 0 && imageView.frame.maxY <= VMSize.height {
                position.y = 0
            }

            imageView.center = CGPoint(x: imageView.center.x + position.x, y: imageView.center.y + position.y)
            pan.setTranslation(CGPoint.zero, in: imageView.superview!)

        }
    }
}

