//
//  Errors.swift
//  SwiftModules
//
//  Created by ash on 2020/8/24.
//  Copyright © 2020 cc. All rights reserved.
//

import Foundation

/// 格式化一下Error
public enum NetworkError: Error {
    /// 网络错误
    case network(value: Error)
    /// 服务器错误
    case service(code: Int, message: String)
    /// 返回字段不是 code 不符合 success 的方式; 或者文本的提示Error
    case error(value: String)
    /// 空数据错误 codew == success, 但是data字段无效或者为null
    case emptyData
}

public extension Error {
    func mapError() -> NetworkError {
        if let error = self as? NetworkError {
            return error
        }
        if let moyaError = self as? MoyaError {
            switch moyaError {
            case .requestMapping(let message):
                return .error(value: message)
            case .encodableMapping(let error):
                return .network(value: error)
            default:
                // 待补充
                break
            }
        }
        return .error(value: self.localizedDescription)
    }
}


extension NetworkError {
    /// 错误描述
    var value: String {
        #if DEBUG
        switch self {
        case let .network(error):
            return "网络错误：\(error)"
        case let .service(value):
            return "服务器错误 code: \(value.code)  msg: \(value.message)"
        case let .error(value: err):
            return err
        case .emptyData:
            return ""
        }
        #else
        switch self {
        case let .network(error):
            return "\(error)"
        case let .service(value):
            return "\(value.message)"
        case let .error(value: err):
            return err
        case .emptyData:
            return ""
        }
        #endif
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.network, .network): return true
        case (.service, .service): return true
        case (.error, .error): return true
        case (.emptyData, .emptyData): return true
        default: return false
        }
    }

}
