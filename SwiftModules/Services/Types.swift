//
//  Types.swift
//  SwiftModules
//
//  Created by ash on 2020/8/21.
//  Copyright © 2019 cc. All rights reserved.
//

import Foundation

protocol AutoParamsType: ParamsType {}

/// 网络参数协议
protocol ParamsType {
    /// 转换到参数字典
    var paramsValue: [String: Any] { get }
}

extension Dictionary: ParamsType {
    var paramsValue: [String: Any] {
        return self as? [String: Any] ?? [:]
    }
}

public struct CodeSet: OptionSet {
    
    public var rawValue: UInt {
        if self == .code_X {
            return _codeValue
        }
        return self.rawValue
    }
    
    static let code_0 = CodeSet(rawValue: 0)
    
    static let code_100 = CodeSet(rawValue: 100)
    
    static let code_200 = CodeSet(rawValue: 200)
    
    static let code_X = CodeSet(rawValue: 999)
    
    static let all: CodeSet = [.code_200, code_0]
    
    var _codeValue: UInt = 999
    
    public init(rawValue: UInt) {
        _codeValue = rawValue
        if rawValue == 0 {
            self = .code_0
        }else if rawValue == 100 {
            self = .code_100
        }else if rawValue == 200 {
            self = .code_200
        }else {
            self = .code_X
        }
    }
}

/// 网络请求Key值, 外部可根据实际需求更改值
public struct NetworkConfigure {
    
    public private(set) static var codeKey = "code"
    public private(set) static var messageKey = "msg"
    public private(set) static var dataKey = "data"
    /// 成功的code值 默认为 200, 0
    public private(set) static var success: CodeSet = CodeSet.all
    
    /// 替换默认的网络请求Key
    public static func replace(
        codeKey: String = NetworkConfigure.codeKey,
        messageKey: String = NetworkConfigure.messageKey,
        dataKey: String = NetworkConfigure.dataKey,
        successCode: CodeSet = NetworkConfigure.success) {
        self.codeKey = codeKey
        self.messageKey = messageKey
        self.dataKey = dataKey
        self.success = successCode
    }
}

public extension Notification.Name {
    
    /// 服务器401通知
    static let networkService_401 = Notification.Name("network_service_401")
    
    /// 服务器402 - 499通知，接收时解析code的字段为："code"
    static let networkService_4XX = Notification.Name("network_service_4XX")
    
    /// 网路可达性改变通知
    static let reachabilityChanged = Notification.Name("reachabilityChanged")
    
}


