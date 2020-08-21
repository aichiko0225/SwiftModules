//
//  DoubleExtensions.swift
//  EZSwiftExtensionsExample
//
//  Created by Goktug Yilmaz on 12/19/15.
//  Copyright © 2015 Goktug Yilmaz. All rights reserved.
//

import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence

extension Double {
    
    /// Creating the exponent operator
    static public func ** (lhs: Double, rhs: Double) -> Double {
        return pow(lhs, rhs)
    }
}
