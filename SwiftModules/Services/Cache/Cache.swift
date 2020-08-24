//
//  Cache.swift
//  SwiftModules
//
//  Created by ash on 2020/8/24.
//  Copyright © 2020 cc. All rights reserved.
//

import Foundation
import YYCache

open class Cache {
    
    // MARK: public properties
    public static let `default` = Cache(with: "RequestCache")
    
    // MARK: private properties
    private let cacheManager: YYCache!
    
    public init(with name: String) {
        cacheManager = YYCache(name: name)!
    }
    
    // MARK: - Public
    
    public func setObject<T: NSCoding>(_ object: T, key: String, completion: (() -> Void)? = nil) {
        cacheManager.setObject(object, forKey: key, with: completion)
    }
    
    public func object<T: NSCoding>(key: String, modelType: T.Type) -> T? {
        return cacheManager.object(forKey: key) as? T
    }
    
    public func object<T: NSCoding>(with key: String, modelType: T.Type, block: ((String, T) -> Void)?) {
        cacheManager.object(forKey: key) { (str, id) in
            if let t_id = id as? T {
                block?(str, t_id)
            }
        }
    }
    
    public func containsObject(key: String) -> Bool {
        return cacheManager.containsObject(forKey: key)
    }
    
    public func removeObject(key: String, completion: ((String) -> Void)? = nil) {
        cacheManager.removeObject(forKey: key, with: completion)
    }
    
    public func removeAllObjects(progressBlock: ((_ removedCount: Int32, _ totalCount: Int32) -> Void)? = nil,
                                 endBlock: ((Bool) -> Void)? = nil) {
        cacheManager.removeAllObjects(progressBlock: progressBlock, end: endBlock)
    }
    
}
