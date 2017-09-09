//
//  HTTPClient.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


open class HTTPClient: NSObject {
    open var baseURL: URL?
    open var requestSerializer: URLRequestSerialization = URLRequestSerializer()
    open var responseParser: URLResponseParsing = URLResponseJSONParser()
    
    open lazy var session: URLSession = {
        return URLSession.shared
    }()
    
    open lazy var commonHeaders: HTTPHeaders = {
        return [:]
    }()
    
    fileprivate var sessionTasks = [URLRequest: URLSessionTask]()
}


public extension HTTPClient {
    public typealias RequestCompletion = (Any?, Error?) -> Void
    
    private func task(for method: HTTPMethod,
                      endpoint: String,
                      parameters: JSONObject? = nil,
                      headers: HTTPHeaders? = nil,
                      completion: RequestCompletion? = nil) throws -> URLSessionTask
    {
        guard let url = baseURL == nil ? URL(string: endpoint) : URL(string: endpoint, relativeTo: baseURL!) else {
            throw NetworkingError.invalidURL(endpoint)
        }
        
        let request = try requestSerializer.request(using: method,
                                                    url: url,
                                                    parameters: parameters ?? [:],
                                                    headers: headers ?? commonHeaders)
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            defer {
                self?.sessionTasks[request] = nil
                NetworkActivityManager.shared.decrement()
            }
            
            guard error == nil else {
                self?.run(completion, object: nil, error: error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self?.run(completion, object: nil, error: NetworkingError.invalidResponse(response!))
                return
            }
            
            let parsedData: Any?
            
            do {
                parsedData = try self?.responseParser.parse(data, response: httpResponse)
            } catch {
                self?.run(completion, object: nil, error: error)
                return
            }
            
            guard 300 >= httpResponse.statusCode && httpResponse.statusCode >= 200 else {
                self?.run(completion, object: parsedData, error: NetworkingError.nonSuccessResponse(httpResponse))
                return
            }
            
            self?.run(completion, object: parsedData, error: nil)
        }
        
        NetworkActivityManager.shared.increment()
        sessionTasks[request] = task
        task.resume()
        
        return task
    }
    
    private func run(_ completion: RequestCompletion?, object: Any?, error: Error?) {
        DispatchQueue.main.async {
            completion?(object, error)
        }
    }
    
    @discardableResult
    func get(_ endpoint: String,
             parameters: JSONObject? = nil,
             headers: HTTPHeaders? = nil,
             completion: RequestCompletion? = nil) throws -> URLSessionTask
    {
        return try task(for: .get, endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }
    
    @discardableResult
    func post(_ endpoint: String,
              parameters: JSONObject? = nil,
              headers: HTTPHeaders? = nil,
              completion: RequestCompletion? = nil) throws -> URLSessionTask
    {
        return try task(for: .post, endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }
    
    @discardableResult
    func put(_ endpoint: String,
             parameters: JSONObject? = nil,
             headers: HTTPHeaders? = nil,
             completion: RequestCompletion? = nil) throws -> URLSessionTask
    {
        return try task(for: .put, endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }
    
    @discardableResult
    func delete(_ endpoint: String,
                parameters: JSONObject? = nil,
                headers: HTTPHeaders? = nil,
                completion: RequestCompletion? = nil) throws -> URLSessionTask
    {
        return try task(for: .delete, endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }
}


public extension HTTPClient {
    func cancel(task: URLSessionTask) {
        var foundRequest: URLRequest? = nil
        
        for (request, ownedTask) in sessionTasks {
            if task == ownedTask {
                task.cancel()
                NetworkActivityManager.shared.decrement()
                foundRequest = request
                break
            }
        }
        
        if let request = foundRequest {
            sessionTasks.removeValue(forKey: request)
        }
    }
    
    func cancelAllTasks() {
        for task in sessionTasks.values {
            task.cancel()
            NetworkActivityManager.shared.decrement()
        }
        sessionTasks.removeAll()
    }
}
