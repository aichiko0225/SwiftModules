//
//  ResponsePlugin.swift
//  SwiftModules
//
//  Created by ash on 2019/10/16.
//

import Foundation
import Moya

public class ResponsePlugin: PluginType {
    public init() {}

    /// Called to modify a result before completion.
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let value):
            do {
                let anyData = try value.mapJSON()
                // 如果不是字典自动失败
                guard let jsonDictionary = anyData as? NSDictionary else {
                    let errorStr = "无效的json格式"
                    return .failure(MoyaError.requestMapping(errorStr))
                }
                return .success(value)
            } catch {
                let error = MoyaError.jsonMapping(value)
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        switch result.status {
//        case .success: break
//        case .unlogin: break
//        default: break
////            HUD.showText(result.message)
//        }
    }
    
}
