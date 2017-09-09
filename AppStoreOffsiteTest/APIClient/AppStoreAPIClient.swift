//
//  AppStoreAPIClient.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

class AppStoreAPIClient: HTTPClient {
    static var shared = AppStoreAPIClient()
    
    override init() {
        super.init()
        
        baseURL = URL(string: "https://itunes.apple.com/hk/")
    }
    
    
    func paginatorOfApps() -> Paginator<App> {
        let paginator: Paginator<App> = Paginator(baseURL: URL(string: "rss/topfreeapplications/",
                                                               relativeTo: baseURL)!,
                                                  fieldName: "entry")
        paginator.limit = 10
        paginator.fetcher = self
        return paginator
    }
    
    func fetchAppDetails(of appID: String, completion: @escaping (JSONObject?, Error?) -> Void) {
        do {
            try get(URL(string: "lookup?id=\(appID)",
                relativeTo: baseURL)!.absoluteString.urlQueryEncoded, parameters: nil) { (object, error) in
                    guard error == nil else {
                        completion(nil, error!)
                        return
                    }
                    
                    
                    guard let result = ((object as? JSONObject)?["results"] as? [JSONObject])?.first else {
                        completion(nil, error)
                        
                        return
                    }
                        
                
                    completion(result, nil)
            }
        } catch { completion(nil, error) }
    }
    
}
