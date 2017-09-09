//
//  Array+JSONRepresentable.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

extension Array where Element: JSONObjectRepresentable {
    static func parsedArray(from array: [JSONObject], skipErrorObject flag: Bool = false) -> Array? {
        var result = self.init()
        for item in array {
            if let value = Element.from(jsonObject: item) {
                result.append(value)
            } else if flag {
                continue
            } else {
                return nil
            }
        }
        return result
    }
}

extension Array where Element: JSONValueRepresentable {
    static func parsedArray(from array: [Any], skipErrorObject flag: Bool = false) -> Array? {
        var result = self.init()
        for item in array {
            if let value = Element.from(jsonValue: item) {
                result.append(value)
            } else if flag {
                continue
            } else {
                return nil
            }
        }
        return result
    }
}

