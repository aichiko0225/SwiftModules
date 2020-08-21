//
//  FileManagerExtension.swift
//  EZSwiftExtensions
//
//  Created by Albert Vila on 16/11/16.
//  Copyright © 2016 Goktug Yilmaz. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// Returns path of documents directory
    public var documentsDirectoryPath: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths.first
    }
    
    /// Returns path of documents directory caches
    public var cachesDirectoryPath: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths.first
    }

}
