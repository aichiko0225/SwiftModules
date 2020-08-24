//
//  CacheViewController.swift
//  SwiftModulesDemo
//
//  Created by ash on 2020/8/24.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit
import RxSwift

class CacheViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let networking = Networking<TestApi>()
//        let _ = networking.cacheRequest(.test1, cacheType: .default) { (result) in
//            log.info("获得请求结果！！！")
//            log.info(result.json as Any)
//            log.info("获得请求结果结束！！！")
//        }
        
        networking.rx.cacheRequest(.test1).mapJSON()
            .subscribe(onNext: { (dic) in
                log.info("rx_获得请求结果！！！")
                log.info(dic)
                log.info("rx_获得请求结果结束！！！")
            }, onError: { (error) in
                log.error(error.mapError())
            }).disposed(by: disposeBag)
    }
    
}
