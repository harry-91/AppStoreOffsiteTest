//
//  JSONValueRepresentable.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

public protocol JSONValueRepresentable {
    static func from(jsonValue: Any?) -> Self?
}


public extension JSONValueRepresentable {
    static func from(jsonValue: Any?) -> Self? {
        return jsonValue as? Self
    }
}


extension String: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> String? {
        if let value = jsonValue as? String {
            return value
        }
        if let value = jsonValue as? NSNumber {
            return value.stringValue
        }
        if jsonValue is UIImage {
            return nil
        }
        if let value = jsonValue as? CustomStringConvertible {
            return value.description
        }
        return nil
    }
}

extension URL: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> URL? {
        guard let urlString = String.from(jsonValue: jsonValue) else {
            return nil
        }
        
        return URL(string: urlString)
    }
}

extension Int: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> Int? {
        if let value = jsonValue as? Int {
            return value
        }
        if let value = jsonValue as? NSNumber {
            return value.intValue
        }
        if let value = jsonValue as? NSString {
            return value.integerValue
        }
        return nil
    }
}


extension Float: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> Float? {
        if let value = jsonValue as? Float {
            return value
        }
        if let value = jsonValue as? NSNumber {
            return value.floatValue
        }
        if let value = jsonValue as? NSString {
            return value.floatValue
        }
        return nil
    }
}


extension Double: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> Double? {
        if let value = jsonValue as? Double {
            return value
        }
        if let value = jsonValue as? NSNumber {
            return value.doubleValue
        }
        if let value = jsonValue as? NSString {
            return value.doubleValue
        }
        return nil
    }
}


extension Bool: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> Bool? {
        if let value = jsonValue as? Bool {
            return value
        }
        if let value = jsonValue as? NSNumber {
            return value.boolValue
        }
        if let value = jsonValue as? NSString {
            return value.boolValue
        }
        return nil
    }
}


extension CGFloat: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> CGFloat? {
        if let value = jsonValue as? CGFloat {
            return value
        }
        if let value = jsonValue as? NSNumber {
            return CGFloat(value.doubleValue)
        }
        if let value = jsonValue as? String,
            let double = Double(value)
        {
            return CGFloat(double)
        }
        return nil
    }
}

extension Decimal: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> Decimal? {
        if let value = jsonValue as? Decimal? {
            return value
        }
        if let value = jsonValue as? NSDecimalNumber {
            return (value as Decimal)
        }
        if let value = jsonValue as? NSNumber {
            return self.init(string: value.stringValue)
        }
        if let numString = jsonValue as? String {
            return self.init(string: numString)
        }
        return nil
    }
}

extension Date: JSONValueRepresentable {
    public static func from(jsonValue: Any?) -> Date? {
        if let date = jsonValue as? Date {
            return date
        }
        guard let dateString = jsonValue as? String else {
            return nil
        }
        let formatter = DateFormatter()
        let formats = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        ]
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
}
