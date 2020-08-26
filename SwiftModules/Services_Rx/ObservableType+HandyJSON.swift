//
//  ObservableType+HandyJSON.swift
//  SwiftModules
//
//  Created by ash on 2019/3/2.
//  Copyright © 2019 cc. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import HandyJSON

public extension ObservableType where Element: Response {

    public func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapModel(T.self))
        }
    }
    
    
    public func mapModel<T: HandyJSON>(_ type: T.Type, atKeyPath keyPath: String) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapModel(T.self, atKeyPath: keyPath))
        }
    }
    
    func mapArray<T: HandyJSON>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type))
        }
    }
    
    func mapArray<T: HandyJSON>(_ type: T.Type, atKeyPath keyPath: String) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type, atKeyPath: keyPath))
        }
    }

}
