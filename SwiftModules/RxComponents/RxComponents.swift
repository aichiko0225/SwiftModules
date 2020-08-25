//
//  RXComponent.swift
//  SwiftComponentsDemo
//
//  Created by ash on 2020/8/7.
//  Copyright © 2020 cc. All rights reserved.
//

import Foundation
@_exported import RxSwift
@_exported import RxCocoa
@_exported import RxRelay
@_exported import RxDataSources

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

public extension SectionModel {
    subscript(_ index: Int) -> ItemType {
        return items[index]
    }
}
