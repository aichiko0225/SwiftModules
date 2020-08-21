//
//  HashableExtensions.swift
//  SwiftExtensions
//
//  Created by Rugen Heidbuchel on 01/08/2018.
//  Copyright © 2018 Goktug Yilmaz. All rights reserved.
//

import Foundation

extension Hashable {
    var hashString: String {
        return String(self.hashValue)
    }
}
