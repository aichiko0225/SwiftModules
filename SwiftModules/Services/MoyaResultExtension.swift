//
//  File.swift
//  SwiftModules
//
//  Created by ash on 2020/8/21.
//  Copyright © 2020 cc. All rights reserved.

import Foundation
import Moya
import SwiftyJSON

public typealias MoyaResult = Result<Moya.Response, MoyaError>

//MARK: - Result Extension
public extension Result {
    typealias Success = Success
    typealias Failure = Failure
}

//Result<Moya.Response, MoyaError>
public extension Result where Result.Success == Moya.Response {
    
    var rawReponse: Moya.Response? { //原始的 Response
        switch self {
        case let .success(value):
            return value as? Response
        case .failure:
            return nil
        }
    }
    
    var json: JSON? { // 原始Response 转data
        guard let data = rawReponse?.data else {
            return nil
        }
        return try? JSON(data: data)
    }
    
    var code: Int {
        return json?["code"].intValue ?? -1000
    }
    
    var message: String {
        return json?["message"].stringValue ?? ""
    }
    
    // 有个字段叫 data
    var rawData: Any? {
        return json?["data"].rawValue
    }
    
    var dataJson: JSON? {
        return json?["data"]
    }
    
    //MARK: - 其他
    var isSuccess: Bool {
        return code == 0
    }
}

public extension Result where Result.Failure == MoyaError {
    var error: MoyaError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
