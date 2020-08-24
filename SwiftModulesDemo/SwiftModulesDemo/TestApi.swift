//
//  TestApi.swift
//  SwiftModulesDemo
//
//  Created by 赵光飞 on 2020/8/24.
//  Copyright © 2020 cc. All rights reserved.
//

import Foundation
import Moya

typealias HTTPMethod = Moya.Method

enum TestApi: CacheTargetType {
    
    case test1
    
    var baseURL: URL {
        return URL(string: "http://news-at.zhihu.com/api/4")!
    }
    
    var path: String {
        return "/news/latest"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var cacheOption: CacheOptions {
        return .loadCache
    }
    
}
