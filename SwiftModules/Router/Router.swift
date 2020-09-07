//
//  Router.swift
//  SwiftComponentsDemo
//
//  Created by liangze on 2020/8/14.
//  Copyright © 2020 liangze. All rights reserved.
//

import UIKit
@_exported import URLNavigator

//MARK: - 给Navigator 添加一个postValue方法 用于 B模块 主动从 A模块获取值
public typealias URLPostHandlerFactory = (_ url: URLNavigator.URLConvertible, _ values: [String: Any], _ context: Any?) -> Any?

public typealias URLPostHandler = () -> Any?

open class Router: Navigator {
    
    private var postValueFactories = [URLPattern: URLPostHandlerFactory]()
    
    open func addPost(_ pattern: URLPattern, _ factory: @escaping URLPostHandlerFactory) {
      self.postValueFactories[pattern] = factory
    }
    
    open func handlerPost(for url: URLNavigator.URLConvertible, context: Any?) -> URLPostHandler? {
       let urlPatterns = Array(self.postValueFactories.keys)
       guard let match = self.matcher.match(url, from: urlPatterns) else { return nil }
       guard let handler = self.postValueFactories[match.pattern] else { return nil }
       return { handler(url, match.values, context) }
     }
    
    @discardableResult
    public func postURL(_ url: URLNavigator.URLConvertible, context: Any?) -> Any? {
      guard let handler = self.handlerPost(for: url, context: context) else { return nil }
      return handler()
    }
}
