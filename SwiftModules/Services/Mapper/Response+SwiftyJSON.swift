//
//  Response+SwiftyJSON.swift
//  SwiftModules
//
//  Created by ash on 2019/10/17.
//  Copyright © 2019 cc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

public extension Response {

    public func mapStringValue() throws -> String {
        do {
            let json = JSON(try mapJSON())
            return json.stringValue
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapBoolValue() throws -> Bool {
        do {
            let json = JSON(try mapJSON())
            return json.boolValue
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapArrayValue() throws -> [String] {
        do {
            let json = JSON(try mapJSON())
            return json.arrayValue.map({ $0.stringValue })
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapStringValue(atKeyPath keyPath: String) throws -> String {
        do {
            let json = JSON(try mapJSON())
            return json[keyPath].stringValue
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapBoolValue(atKeyPath keyPath: String) throws -> Bool {
        do {
            let json = JSON(try mapJSON())
            return json[keyPath].boolValue
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapArrayValue(atKeyPath keyPath: String) throws -> [String] {
        do {
            let json = JSON(try mapJSON())
            return json[keyPath].arrayValue.map({ $0.stringValue })
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

}

public extension Response {

    public func mapString() throws -> String? {
        do {
            let json = JSON(try mapJSON())
            return json.stringValue
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapBool() throws -> Bool? {
        do {
            let json = JSON(try mapJSON())
            return json.bool
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapArray() throws -> [String?] {
        do {
            let json = JSON(try mapJSON())
            return json.arrayValue.map({ $0.string })
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapString(atKeyPath keyPath: String) throws -> String? {
        do {
            let json = JSON(try mapJSON())
            return json[keyPath].string
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapBool(atKeyPath keyPath: String) throws -> Bool? {
        do {
            let json = JSON(try mapJSON())
            return json[keyPath].bool
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }

    public func mapArray(atKeyPath keyPath: String) throws -> [String?] {
        do {
            let json = JSON(try mapJSON())
            return json[keyPath].arrayValue.map({ $0.string })
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
}
