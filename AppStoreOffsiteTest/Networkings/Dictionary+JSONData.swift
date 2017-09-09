//
//  Dictionary+JSONData.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

internal extension Dictionary {
    var dataRepresentation: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
        } catch {
            return nil
        }
    }
}
