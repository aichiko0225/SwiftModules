//
//  NetworkPlugin.swift
//  SwiftModules
//
//  Created by liangze on 2019/12/17.
//  Copyright © 2019 liangze. All rights reserved.
//

import Foundation
import Moya
import SwiftyBeaver

/// 通用网络插件
public class CCNetworkLoggerPlugin: PluginType {
    /// 开始请求字典
    private static var startDates: [String: Date] = [:]
    
    private static let lock = NSLock()
    
    public init() {
        
    }
    
    /// 即将发送请求
    public func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        // 设置当前时间
        CCNetworkLoggerPlugin.lock.lock()
        defer {
            CCNetworkLoggerPlugin.lock.unlock()
        }
        CCNetworkLoggerPlugin.startDates[String(describing: target)] = Date()
        #endif
    }
    
    
    /// 收到请求时
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        guard let startDate = CCNetworkLoggerPlugin.startDates[String(describing: target)] else { return }
        // 获取当前时间与开始时间差（秒数）
        let requestDate = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
        printLog("================================请求日志==============================")
        if let url = result.rawReponse?.request?.url?.absoluteString {
           printLog("URL : \(url)")
        } else {
           printLog("URL : \(target.baseURL)\(target.path)")
        }
        printLog("请求方式：\(target.method.rawValue)")
        printLog("请求时间 : \(String(format: "%.1f", requestDate))s")
        printLog("请求头：\(target.headers ?? [:])")
        if let request = result.rawReponse?.request {
            switch target.task {
            case .requestPlain, .uploadMultipart: break
            case let .requestParameters(parameters, _), let .uploadCompositeMultipart(_, parameters):
                printLog("请求参数 : \(parameters)")
            default:
                if let requestBody = request.httpBody {
                    let decrypt = requestBody.parameterString()
                    printLog("请求参数 : \(decrypt)")
                }
            }
        }
        
        switch result {
        case let .success(response):
            printLog("响应数据：\n \(String(data: response.data, encoding: .utf8) ?? "")")
        case let .failure(error):
            printLog("请求错误：\(error)")
        }
        printLog("==================================================================")
        
        // 删除完成的请求开始时间
        CCNetworkLoggerPlugin.startDates.removeValue(forKey: String(describing: target))
        #endif
    }
}


fileprivate extension Data {
    func parameterString() -> String {
        guard let json = try? JSONSerialization.jsonObject(with: self),
            let value = json as? [String : Any] else {
            return ""
        }
        return "\(value)"
    }
}

private let log = SwiftyBeaver.self

func printLog<T>(_ msg: T) {
    #if DEBUG
    log.info("\(msg)")
    #endif
}

func printLog<T>(_ msgArr: T...) {
    #if DEBUG
    func msg() -> String {
        var str = ""
        for t in msgArr {
            str += "\(t)"
        }
        return str
    }

    log.info(msg())
    #endif
}
