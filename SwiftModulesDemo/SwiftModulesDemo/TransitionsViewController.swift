//
//  TransitionsViewController.swift
//  SwiftModulesDemo
//
//  Created by 赵光飞 on 2020/8/28.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit

class WWAlertViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}


/// 介绍转场动画的 Controller
class TransitionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemOrange
        let filterTransition = FilterTransition()
        vc.transitioningDelegate = filterTransition
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
}
