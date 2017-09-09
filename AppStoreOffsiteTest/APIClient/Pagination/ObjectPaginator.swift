//
//  ObjectPaginator.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

private struct Static {
    static var fetcher: ObjectsFetching = HTTPClient()
}

open class Paginator<T: JSONObjectRepresentable> {
    
    public typealias completionType = ([T], Error?) -> ()
    
    open var limit = 8
    fileprivate(set) open var page = 0
    
    
    fileprivate(set) open var canFetchNext = true
    var canFetchPrevious: Bool {
        return page != 1
    }
    fileprivate(set) open var baseURL: URL
    fileprivate(set) open var fieldName: String
    
    fileprivate var nextURL: URL {
        page += 1
        
        return URL(string: baseURL.absoluteString.appending("limit=\(limit * page)/json"))!
    }
    fileprivate var previousURL: URL {
        if page > 1 {
            page -= 1
        }
        
        return URL(string: baseURL.absoluteString.appending("limit=\(limit * page)/json"))!
    }
    
    open var fetcher = Paginator.sharedFetcher
    
    public init(baseURL: URL, fieldName: String) {
        self.baseURL = baseURL
        self.fieldName = fieldName
    }
    
    public func reset() {
        page = 1
    }
}


public extension Paginator {
    public static var sharedFetcher: ObjectsFetching {
        get { return Static.fetcher }
        set { Static.fetcher = newValue }
    }
}


public extension Paginator {
    
    func fetchNext(_ completion: completionType? = nil) {
        fetch(url: nextURL, completion: completion)
    }
    
    func fetchPrevious(_ completion: completionType? = nil) {
        fetch(url: previousURL, completion: completion)
    }
    
    private func fetch(url: URL?, completion: completionType?) {
        guard let url = url else {
            completion?([], nil)
            return
        }
        fetcher.fetchObjects(from: url) { [weak self] (objects, error) in
            self?.verifyResponse(objects: objects, error: error, completion: completion)
        }
    }
    
    
    private func verifyResponse(objects: JSONObject?, error: Error?, completion: completionType?) {
        
        guard error == nil else {
            completion?([], error)
            return
        }
        
        guard let objects = objects,
            let data = objects["feed"] as? JSONObject else {
            completion?([], nil)
            return
        }
        
        
        if let limit: Int = data.get("limit") {
            self.limit = limit
        }
        if let page: Int = data.get("page") {
            self.page = page
        }
        
        let results: [T] = data.getList(fieldName) ?? []
        
        completion?(results, nil)
    }
}

