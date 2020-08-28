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


public protocol ViewModelInput {
    var activity: PublishSubject<Void> { get }
}
public protocol ViewModelOutput {
    
}

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

public typealias NormalViewModelProtocol = NormalViewModelType & NormalViewModelOutput & NormalViewModelInput

public protocol NormalViewModelOutput {
    var message: PublishSubject<String> { get }
    var isLoading: PublishSubject<Bool> { get }
}

public protocol NormalViewModelInput {
    
}

public protocol NormalViewModelType {
    var inputs: NormalViewModelInput { get }
    var outputs: NormalViewModelOutput { get }
}

public extension SectionModel {
    subscript(_ index: Int) -> ItemType {
        return items[index]
    }
}
