//
//  ObjectFetching.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

public protocol ObjectsFetching {
    func fetchObjects(from url: URL, completion: @escaping (JSONObject?, Error?) -> ())
}


extension HTTPClient: ObjectsFetching {
    public func fetchObjects(from url: URL, completion: @escaping (JSONObject?, Error?) -> ()) {
        do {
            try get(url.absoluteString.urlQueryEncoded, parameters: nil) { (object, error) in
                guard error == nil else {
                    completion(nil, error!)
                    return
                }
                
                completion(object as? JSONObject ?? [:], nil)
            }
        } catch { completion(nil, error) }
    }
}
