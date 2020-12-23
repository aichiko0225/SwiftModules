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
        guard let authorizable = target as? AccessTokenAuthorizable else { return request }

        let authorizationType = authorizable.authorizationType
        var request = request
        
        func tokenClosure(_ authorizationType: AuthorizationType) -> String? {
            switch authorizationType {
            case .basic:
                break
            case .bearer:
                break
            case .custom(let token):
                return token
            }
            return nil
        }
        
       if let authorizationType = authorizationType {
            let authValue = tokenClosure(authorizationType) ?? ""
            if !authValue.isEmpty {
                request.addValue(authValue, forHTTPHeaderField: "Authorization")
            }        }
        return request
    }
}
