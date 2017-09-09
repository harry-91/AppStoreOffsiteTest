//
//  Dictionary+JSONRepresentable.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

// MARK: - Getting JSONObjectRepresentable

public extension Dictionary where Key == String, Value == Any {
    public func get<T: JSONObjectRepresentable>(_ name: Key, default value: T? = nil) -> T? {
        guard self[name] as? NSNull == nil else {
            return nil
        }
        
        guard let object = self[name] as? JSONObject else {
            return value
        }
        
        return T.from(jsonObject: object) ?? value
    }
    
    public func getList<T: JSONObjectRepresentable>(_ name: Key, skipErrorObject flag: Bool = false) -> [T]? {
        guard let objects = self[name] as? [JSONObject] else {
            return nil
        }
        
        return [T].parsedArray(from: objects, skipErrorObject: flag)
    }
}


// MARK: - Getting JSONValueRepresentable

public extension Dictionary where Key == String, Value == Any {
    public func get<T: JSONValueRepresentable>(_ name: Key, default value: T? = nil) -> T? {
        guard self[name] as? NSNull == nil else {
            return nil
        }
        
        return T.from(jsonValue: self[name]) ?? value
    }
    
    public func getList<T: JSONValueRepresentable>(_ name: Key, skipErrorValue flag: Bool = false) -> [T]? {
        guard let values = self[name] as? [Any] else {
            return nil
        }
        
        return [T].parsedArray(from: values, skipErrorObject: flag)
    }
}

