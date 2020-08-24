//
//  NetworkHeaderPlugin.swift
//  SwiftModules
//
//  Created by liangze on 2019/12/17.
//  Copyright © 2019 liangze. All rights reserved.
//

import Foundation
import Moya

// 加入默认的header
class NetworkHeaderPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var newRequest = request
//        if let header = Network.configs.additionHeader {
//            header.forEach { (key, value) in
//                newRequest.setValue(value, forHTTPHeaderField: key)
//            }
//        }
        return newRequest
    }
}
