//
//  URLRequestSerializer.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

public typealias HTTPHeaders = [String: String]
public typealias JSONObject = [String: Any]


public protocol URLRequestSerialization {
    func request(using method: HTTPMethod, url: URL, parameters: JSONObject, headers: HTTPHeaders) throws -> URLRequest
}


extension URLRequest {
    mutating func update(headers: HTTPHeaders) {
        for (key, value) in headers {
            setValue(value, forHTTPHeaderField: key)
        }
    }
}


public class URLRequestSerializer: URLRequestSerialization {
    
    private lazy var querySerializer = URLRequestQuerySerializer()
    private lazy var jsonSerializer = URLRequestJSONSerializer()
    private lazy var multipartSerializer = URLRequestMultipartSerializer()
    
    public func request(using method: HTTPMethod, url: URL, parameters: JSONObject = [:], headers: HTTPHeaders = [:]) throws -> URLRequest
    {
        switch method {
        case .post, .put:
            for value in parameters.values {
                if value is UIImage {
                    return try multipartSerializer.request(using: method, url: url, parameters: parameters, headers: headers)
                }
            }
            return try jsonSerializer.request(using: method, url: url, parameters: parameters, headers: headers)
            
        default:
            return try querySerializer.request(using: method, url: url, parameters: parameters, headers: headers)
        }
        
    }
}


public class URLRequestQuerySerializer: URLRequestSerialization {
    public func request(using method: HTTPMethod, url: URL, parameters: JSONObject = [:], headers: HTTPHeaders = [:]) throws ->  URLRequest
    {
        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            throw NetworkingError.invalidURL(url.absoluteString)
        }
        
        var queryItems = urlComponents.queryItems ?? [URLQueryItem]()
        for (key, value) in parameters {
            guard let string = parameters[key] as? String else {
                throw NetworkingError.invalidParameter(key: key, value: value)
            }
            queryItems.append(URLQueryItem(name: key, value: string))
        }
        
        urlComponents.queryItems = queryItems.count > 0 ? queryItems : nil
        
        guard let finalURL = urlComponents.url else {
            throw NetworkingError.invalidURL(url.absoluteString)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.update(headers: headers)
        
        return request
    }
}


public class URLRequestJSONSerializer: URLRequestSerialization {
    public func request(using method: HTTPMethod, url: URL, parameters: JSONObject = [:], headers: HTTPHeaders = [:]) throws ->  URLRequest
    {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.update(headers: headers)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = parameters.dataRepresentation
        
        return request
    }
}


public class URLRequestMultipartSerializer: URLRequestSerialization {
    public func request(using method: HTTPMethod, url: URL, parameters: JSONObject = [:], headers: HTTPHeaders = [:]) throws ->  URLRequest
    {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.update(headers: headers)
        
        // Set boundary value
        let boundary = "boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        var images = [String: UIImage]()
        
        let boundaryData = "--\(boundary)\r\n".data(using: .utf8)!
        let newLineData = "\r\n".data(using: .utf8)!
        
        // Set text data
        for (key, value) in parameters {
            if let image = value as? UIImage {
                images[key] = image
                continue
            }
            
            guard let stringValue = parameters[key] as? String,
                let stringData = (
                    "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" +
                    "\(stringValue)\r\n").data(using: .utf8)
                else
            {
                throw NetworkingError.invalidParameter(key: key, value: value)
            }
            
            data.append(boundaryData)
            data.append(stringData)
        }
        
        // Set image data
        for (key, image) in images {
            guard let imageData = image.pngData(),
                let stringData = (
                    "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).png\"\r\n" +
                    "Content-Type: image/png\r\n\r\n").data(using: .utf8)
                else
            {
                throw NetworkingError.invalidParameter(key: key, value: image)
            }
            
            data.append(boundaryData)
            data.append(stringData)
            data.append(imageData)
            data.append(newLineData)
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        return request
    }
}

