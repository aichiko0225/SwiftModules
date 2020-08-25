//
//  ViewController.swift
//  SwiftModulesDemo
//
//  Created by ash on 2020/8/18.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit

class AView: UIView {
    
    override func cc_setupUI() {
        debugPrint("setupUI")
    }
    
    override func cc_setupLayout() {
        debugPrint("setupLayout")
    }
    
    override func cc_bindViewModel() {
        debugPrint("bindViewModel")
    }
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        log.debug("11111")
        log.info("22222")
        log.warning("33333")
        log.verbose("44444")
        log.error("55555")
        
        let geolocationService = GeolocationService.instance
        
        geolocationService.authorized.drive(onNext: { (_) in
            
        }).disposed(by: rx.disposeBag)
//            .drive(noGeolocationView.rx.isHidden)
//            .disposed(by: disposeBag)
        
        geolocationService.location.drive(onNext: { (_) in
            
        }).disposed(by: rx.disposeBag)
//            .drive(label.rx.coordinates)
//            .disposed(by: disposeBag)
        
    }

}

