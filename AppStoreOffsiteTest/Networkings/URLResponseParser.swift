//
//  URLResponseParser.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

public protocol URLResponseParsing {
    func parse(_ data: Data?, response: HTTPURLResponse) throws -> Any?
}


class URLResponseDataParser: URLResponseParsing {
    func parse(_ data: Data?, response: HTTPURLResponse) throws -> Any? {
        return data
    }
}


class URLResponseJSONParser: URLResponseParsing {
    func parse(_ data: Data?, response: HTTPURLResponse) throws -> Any? {
        guard let data = data else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            throw NetworkingError.invalidContentTypeResponse(response)
        }
    }
}


class URLResponseImageParser: URLResponseParsing {
    func parse(_ data: Data?, response: HTTPURLResponse) throws -> Any? {
        guard let data = data else {
            return nil
        }
        guard let image = UIImage(data: data) else {
            throw NetworkingError.invalidContentTypeResponse(response)
        }
        
        return image
    }
}
