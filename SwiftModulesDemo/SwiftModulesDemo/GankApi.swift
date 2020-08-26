//
//  GankApi.swift
//  SwiftModulesDemo
//
//  Created by ash on 2020/8/25.
//  Copyright © 2020 cc. All rights reserved.
//

import Foundation

enum GankApi: CacheTargetType {
    
    case girls(size: Int, index: Int)
    
    var baseURL: URL {
        return URL(string: "http://gank.io/api/v2/data/")!
    }
    
    var path: String {
        switch self {
        case .girls(let size, let index):
            return "category/Girl/type/Girl/page/\(index)/count/\(size)"
        }
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

