//
//  MoyaRequest.swift
//  SwiftModules
//
//  Created by ash on 2020/8/24.
//

import Foundation
import Moya

public extension MoyaProviderType {
    
    /**
    缓存网络请求:
    
    - 如果本地无缓存，直接返回网络请求到的数据
    - 如果本地有缓存，先返回缓存，再返回网络请求到的数据
    - 只会缓存请求成功的数据（缓存的数据 response 的状态码为 200-299）
    - 适用于APP首页数据缓存
    */
    
    /// Designated request-making method. Returns a `Cancellable` token to cancel the request later.
    func cacheRequest(_ target: Target,
                      cacheType: CacheKeyType = .default,
                      callbackQueue: DispatchQueue? = .none,
                      progress: Moya.ProgressBlock? = .none,
                      completion: @escaping Moya.Completion) -> Cancellable {
        
        if let cache_target = target as? CacheTargetType {
            // 如果 没有继承 CacheTargetType 则没有缓存的逻辑
            let cacheOption = cache_target.cacheOption
            if cacheOption != .none {
                let cacheM = Cache.default
                if cacheOption == .onlyUpdate {
                    // 只更新缓存，用于以后使用
                }else {
                    // 加载缓存
                    let cacheKey = target.fetchCacheKey(cacheType)
                    if cacheM.containsObject(key: cacheKey) {
                        // 存在缓存
                        // 字典接收
                        let dic = cacheM.object(key: cacheKey, modelType: NSDictionary.self)
                        // 对象接收
                        if let object = cacheM.object(key: cacheKey, modelType: CacheCodingdata.self) {
                            let data = object.cacheData
                            if !data.isEmpty {
                                // data 不为空
                                completion(.success(Response.init(statusCode: 201, data: data)))
                            }
                        }
                    }
                }
            }
        }
        
        return request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            completion(result)
            // add cache
            switch result {
            case .success(let response):
                if let cache_target = target as? CacheTargetType {
                    let cacheOption = cache_target.cacheOption
                    if cacheOption != .none {
                        if let resp = try? response.filterSuccessfulStatusCodes() {
                            // 更新缓存
                            // 需要判断是否为正确的data，如果不是正确的data 则不需要走缓存的机制
                            do {
                                let anyData = try resp.mapJSON()
                                // 如果不是字典 无需缓存
                                guard anyData is NSDictionary else {
                                    return
                                }
                                
                                let codeKey = NetworkConfigure.codeKey
                                let successCode = NetworkConfigure.success
                                let messageKey = NetworkConfigure.messageKey
                                
                                guard let jsonDictionary = anyData as? NSDictionary else {
                                    return
                                }
                                guard let code = jsonDictionary.value(forKeyPath: codeKey) as? Int else {
                                    return
                                }
                                guard successCode.contains(.init(rawValue: code)) else {
                                    return
                                }
                                
                                let cacheM = Cache.default
                                let cacheKey = target.fetchCacheKey(cacheType)
                                let cacheModel = CacheCodingdata(resp.data)
                                cacheM.setObject(cacheModel, key: cacheKey)
                            } catch {
                            }
                        }
                    }
                }
                break
            default:break
            }
            
        }
    }
    
}


