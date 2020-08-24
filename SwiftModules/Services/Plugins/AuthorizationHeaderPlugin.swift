//
//  AuthorizationHeaderPlugi.swift
//  SwiftModules
//
//  Created by liangze on 2019/12/17.
//  Copyright © 2019 liangze. All rights reserved.
// 2

import Foundation
import Moya

public class AuthorizationHeaderPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        guard let authorizable = target as? AccessTokenAuthorizable else { return request }
//
//        let authorizationType = authorizable.authorizationType
//        var request = request
//        
//        func tokenClosure(_ authorizationType: AuthorizationType) -> String? {
//            switch authorizationType {
//            case .basic:
//                let user = "scmapp"
//                let password = "scmappsecret"
//                guard let data = "\(user):\(password)".data(using: .utf8) else { return nil }
//                let credential = data.base64EncodedString(options: [])
//                return credential
//            case .bearer, .custom:
//                break
//            }
//            return nil
//        }
//        
//       if let authorizationType = authorizationType {
//            let authValue = authorizationType.value + " " + (tokenClosure(authorizationType) ?? "")
//            request.addValue(authValue, forHTTPHeaderField: "Authorization")
//        }
        return request
    }
}
