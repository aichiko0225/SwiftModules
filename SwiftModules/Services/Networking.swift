//
//  Networking.swift
//  SwiftModules
//
//  Created by ash on 2019/10/15.
//  Copyright © 2019 cc. All rights reserved.
//

import Foundation
@_exported import Moya
@_exported import Alamofire
@_exported import HandyJSON
import SwiftyJSON
import struct Alamofire.HTTPHeaders

let networkActivityPlugin = NetworkActivityPlugin{ (changeType: NetworkActivityChangeType, targetType: TargetType) in
    
    switch(changeType){
    case .ended:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    case .began:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
}

public protocol NetworkingType {
    associatedtype T: TargetType
    var provider: Networking<T> { get }
}

open class Networking<Target: TargetType>: MoyaProvider<Target> {

    public convenience init(plugins: [PluginType]) {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        self.init(configuration: configuration, plugins: plugins)
    }
    
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.af.default,
         plugins: [PluginType] = []) {
        var newPlugins = plugins
        // logger
        #if DEBUG
        let formatter = NetworkLoggerPlugin.Configuration.Formatter(responseData:  { (data) -> (String) in
            let json = try? JSON(data: data)
            if let dic_value = json?.dictionaryValue {
                return dic_value.description
            }
            return json?.stringValue ?? "## Cannot map data to String ##"
        })
        let config = NetworkLoggerPlugin.Configuration(formatter: formatter, logOptions: .verbose)
        newPlugins.append(NetworkLoggerPlugin(configuration: config))
        #endif
        
//        newPlugins.append(ResponsePlugin())
        
//        newPlugins.append(NetworkHeaderPlugin())
        newPlugins.append(AuthorizationHeaderPlugin())
        // Activity
        newPlugins.append(networkActivityPlugin)
        
        let session = Session.init(configuration: configuration)
//        session.startImmediately = false
        super.init(session: session, plugins: newPlugins)
    }
}

