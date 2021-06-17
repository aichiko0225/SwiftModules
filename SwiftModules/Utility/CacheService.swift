//
//  ImageCacheService.swift
//  SwiftModules
//
//  Created by 赵光飞 on 2020/8/28.
//

import Foundation
import Kingfisher

/// 获取Caches目录路径
fileprivate let cachePath = NSHomeDirectory() + "/Library/Caches"

/// 本地缓存服务
public struct LocalCacheService {
    static let shared = LocalCacheService()
    
    /// 文件管理者
    private let fileManager = FileManager.default
    
    /// 获取缓存文件夹下的缓存大小
    public func fileSizeOfCache()-> Float {
        guard let files = fileManager.subpaths(atPath: cachePath) else {
            return 0
        }
        
        //枚举出所有文件，计算文件大小
        var folderSize: Float = 0
        for file in files {
            // 路径拼接
            let path = "\(cachePath)/\(file)"
            // 计算缓存大小
            folderSize  += fileSizeAtPath(path:path)
        }
        
        return folderSize / (1024 * 1024)
    }
    
    /// 获取指定路径下文件/文件夹内容大小
    public func fileSizeAtPath(path:String) -> Float {
        guard fileManager.fileExists(atPath: path) else { return 0 }
        
        let attr = try! fileManager.attributesOfItem(atPath: path)
        return attr[FileAttributeKey.size] as! Float
    }
    
    /// 清除缓存数据
    public func clearCache() {
        guard let files = fileManager.subpaths(atPath: cachePath) else { return }
        
        for file in files {
            let path = "\(cachePath)/\(file)"
            if fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch  {
                }
            }
        }
    }
}


// MARK: - 图片缓存服务
public struct ImageCacheService {
    static let shared = ImageCacheService()
    
    private init() {}
    
    /// 配置KF缓存
    public func config() {
        // KF 控制最大缓存数
//        ImageCache.default.maxMemoryCost = 20
    }
}
