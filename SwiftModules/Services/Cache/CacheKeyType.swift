//
//  CacheKeyType.swift
//  SwiftModules
//
//  Created by ash on 2020/8/24.
//

import Foundation

// 使用缓存的方式
public enum CacheOptions: Equatable {
    // 不使用缓存
    case none
    // 更新缓存
    case onlyUpdate
    // 加载缓存，网络请求回来之后会更新缓存
    case loadCache
    // 只使用缓存，如果缓存不存在则去请求，如果存在则不会重新请求
    case justCache
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.onlyUpdate, .onlyUpdate):
            return true
        case (.loadCache, .loadCache):
            return true
        case (.justCache, .justCache):
            return true
        default:
            return false
        }
    }
}

public enum CacheKeyType {
    // 默认的方式来作为cacheKey
    case `default`
    // 使用baseCacheKey 来作为cacheKey，这种方式适用于无参数，获取最新数据的请求
    case base
    // 自定义cacheKey
    case custom(String)
}

// MARK: CacheCodingdata
class CacheCodingdata: NSObject, NSSecureCoding {
    
    // 请求的数据
    var cacheData: Data
    
    // 1 根据版本号来废弃缓存
    var version: Double = 1
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    init(_ data: Data, version: Double = 1) {
        self.cacheData = data
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(cacheData)
        coder.encode(version, forKey: "version")
    }
    
    required init?(coder: NSCoder) {
        self.version = coder.decodeDouble(forKey: "version")
        self.cacheData = coder.decodeData() ?? Data()
    }
    
}

