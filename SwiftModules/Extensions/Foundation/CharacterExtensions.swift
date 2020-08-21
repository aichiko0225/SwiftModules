//
//  CharacterExtensions.swift
//  SwiftExtensions
//
//  Created by Goktug Yilmaz on 3/1/16.
//  Copyright © 2016 Goktug Yilmaz. All rights reserved.
//

import Foundation

extension Character {
    /// Converts Character to String //TODO: Add to readme
    public var toString: String { return String(self) }

    /// If the character represents an integer that fits into an Int, returns the corresponding integer.
    ///TODO: Add to readme
    public var toInt: Int? { return Int(String(self)) }

    /// Convert the character to lowercase
    public var lowercased: Character {
            let s = String(self).lowercased()
            return s[s.startIndex]
    }

    /// Convert the character to uppercase
    public var uppercased: Character {
            let s = String(self).uppercased()
            return s[s.startIndex]
    }
    
    /// Checks if character is emoji
    var isEmoji: Bool {
        return String(self).includesEmoji()
    }
}
