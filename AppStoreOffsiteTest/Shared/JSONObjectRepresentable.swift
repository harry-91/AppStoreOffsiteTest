//
//  JSONObjectRepresentable.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

public protocol JSONObjectRepresentable {
    var jsonObject: JSONObject { get }
    
    static func from(jsonObject: JSONObject) -> Self?
}
