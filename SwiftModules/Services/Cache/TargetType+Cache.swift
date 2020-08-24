//
//  TargetType+Cache.swift
//  SwiftModules
//
//  Created by ash on 2020/8/24.
//

import Foundation
import SwiftyJSON
import CommonCrypto

// MARK: CacheOption
/// 扩展一个缓存的类型，子类API 重写 cacheType就可以使用不同的缓存策略
public protocol CacheTargetType: TargetType {
    var cacheOption: CacheOptions { get }
}

// MARK: CacheKey
// 主要是获取cacheKey
public extension TargetType {
    
    func fetchCacheKey(_ type: CacheKeyType) -> String {
        switch type {
        case .base:
            return baseCacheKey.MD5()
        case .default:
            return cacheKey.MD5()
        case let .custom(key):
            return cacheKey(with: key).MD5()
        }
    }
    
    var cacheParameterTypeKey: String {
        return cacheKey(with: "ParameterTypeKey")
    }
    
    private var baseCacheKey: String {
        return "[\(self.method)]\(self.baseURL.absoluteString)/\(self.path)"
    }
    
    private var cacheKey: String {
        let baseKey = baseCacheKey
        if parameters.isEmpty { return baseKey }
        return (baseKey + "?" + parameters)
    }
    
    private func cacheKey(with customKey: String) -> String {
        return (baseCacheKey + "?" + customKey)
    }
    
    private var parameters: String {
        switch self.task {
        case let .requestParameters(parameters, _):
            return JSON(parameters).rawString() ?? ""
        case let .requestCompositeParameters(bodyParameters, _, urlParameters):
            var parameters = bodyParameters
            for (key, value) in urlParameters { parameters[key] = value }
            return JSON(parameters).rawString() ?? ""
        case let .downloadParameters(parameters, _, _):
            return JSON(parameters).rawString() ?? ""
        case let .uploadCompositeMultipart(_, urlParameters):
            return JSON(urlParameters).rawString() ?? ""
        case let .requestCompositeData(_, urlParameters):
            return JSON(urlParameters).rawString() ?? ""
        default: return  ""
        }
    }
}

extension String {
    
    func MD5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
    
}
