//
//  NameSpace.swift
//  SwiftModules
//
//  Created by ash on 2020/8/25.
//

import Foundation

public final class NameSpace<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol Compatible {
    associatedtype CompatibleType
    var cc: CompatibleType { get }
}

public extension Compatible {
    var cc: NameSpace<Self> {
        get { return NameSpace(self) }
    }
}
