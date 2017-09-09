//
//  NetworkingError.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

public enum NetworkingError: Error {
    case invalidURL(String)
    case invalidParameter(key: String, value: Any)
    
    case invalidResponse(URLResponse)
    case invalidContentTypeResponse(HTTPURLResponse)
    case nonSuccessResponse(HTTPURLResponse)
}
