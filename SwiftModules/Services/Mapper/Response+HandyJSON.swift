//
//  Response+HandyJSON.swift
//  SwiftModules
//
//  Created by ash on 2019/3/2.
//  Copyright © 2019 cc. All rights reserved.
//

import Foundation
import Moya
import HandyJSON
import Alamofire

public extension Response {
    
    public func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let result = type.deserialize(from: jsonString) else { throw MoyaError.jsonMapping(self)  }
        return result
    }
    
    public func mapArray<T: HandyJSON>(_ type: T.Type) throws -> [T] {
        guard let array = try mapJSON() as? [[String: Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        guard let modelArr = [T].deserialize(from: array) else {
            throw MoyaError.jsonMapping(self)
        }
        var model_arr: [T] = []
        for model in modelArr {
            if let t_model = model {
                model_arr.append(t_model)
            }
        }
        return model_arr
    }
    
    public func mapModel<T: HandyJSON>(_ type: T.Type, atKeyPath keyPath: String) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let result = type.deserialize(from: jsonString, designatedPath: keyPath) else { throw MoyaError.jsonMapping(self)  }
        return result
    }
    
    public func mapArray<T: HandyJSON>(_ type: T.Type, atKeyPath keyPath: String) throws -> [T] {
        let arrayString = String(data: data, encoding: .utf8)
        guard let modelArr = [T].deserialize(from: arrayString, designatedPath: keyPath) else {
            throw MoyaError.jsonMapping(self)
        }
        var model_arr: [T] = []
        for model in modelArr {
            if let t_model = model {
                model_arr.append(t_model)
            }
        }
        return model_arr
    }
    
}
