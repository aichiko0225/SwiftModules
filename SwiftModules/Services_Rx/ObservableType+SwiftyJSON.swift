//
//  ObservableType+SwiftyJSON.swift
//  SwiftModules
//
//  Created by ash on 2019/10/17.
//  Copyright © 2019 cc. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

public extension ObservableType where Element == Response {

    func mapStringValue() -> Observable<String> {
        return flatMap({ (response) -> Observable<String> in
            return Observable.just(try response.mapStringValue())
        })
    }

    func mapBoolValue() -> Observable<Bool> {
        return flatMap({ (response) -> Observable<Bool> in
            return Observable.just(try response.mapBoolValue())
        })
    }

    func mapArrayValue() -> Observable<[String]> {
        return flatMap({ (response) -> Observable<[String]> in
            return Observable.just(try response.mapArrayValue())
        })
    }

    func mapStringValue(atKeyPath keyPath: String) -> Observable<String> {
        return flatMap({ (response) -> Observable<String> in
            return Observable.just(try response.mapStringValue(atKeyPath: keyPath))
        })
    }

    func mapBoolValue(atKeyPath keyPath: String) -> Observable<Bool> {
        return flatMap({ (response) -> Observable<Bool> in
            return Observable.just(try response.mapBoolValue(atKeyPath: keyPath))
        })
    }

    func mapArrayValue(atKeyPath keyPath: String) -> Observable<[String]> {
        return flatMap({ (response) -> Observable<[String]> in
            return Observable.just(try response.mapArrayValue(atKeyPath: keyPath))
        })
    }

}

// MARK: - ImmutableMappable
public extension ObservableType where Element == Response {

    func mapString() -> Observable<String?> {
        return flatMap({ (response) -> Observable<String?> in
            return Observable.just(try response.mapString())
        })
    }

    func mapBool() -> Observable<Bool?> {
        return flatMap({ (response) -> Observable<Bool?> in
            return Observable.just(try response.mapBool())
        })
    }

    func mapArray() -> Observable<[String?]> {
        return flatMap({ (response) -> Observable<[String?]> in
            return Observable.just(try response.mapArray())
        })
    }

    func mapString(atKeyPath keyPath: String) -> Observable<String?> {
        return flatMap({ (response) -> Observable<String?> in
            return Observable.just(try response.mapString(atKeyPath: keyPath))
        })
    }

    func mapBool(atKeyPath keyPath: String) -> Observable<Bool?> {
        return flatMap({ (response) -> Observable<Bool?> in
            return Observable.just(try response.mapBool(atKeyPath: keyPath))
        })
    }

    func mapArray(atKeyPath keyPath: String) -> Observable<[String?]> {
        return flatMap({ (response) -> Observable<[String?]> in
            return Observable.just(try response.mapArray(atKeyPath: keyPath))
        })
    }
}
