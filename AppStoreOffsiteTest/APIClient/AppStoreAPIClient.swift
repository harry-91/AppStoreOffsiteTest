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
    
    
    // MARK: - Private Actions
    
    fileprivate func fetchAppDetails(of appID: String, completion: @escaping (JSONObject?, Error?) -> Void) {
        do {
            try get(URL(string: "lookup?id=\(appID)",
                relativeTo: baseURL)!.absoluteString.urlQueryEncoded, parameters: nil) { (object, error) in
                    guard error == nil else {
                        completion(nil, error!)
                        return
                    }
                    
                    
                    guard let result = ((object as? JSONObject)?["results"] as? [JSONObject])?.first else {
                        // create new error
                        
                        DispatchQueue.performOnMain({
                            completion(nil, error)
                        })
                        
                        return
                    }
                    
                    
                    DispatchQueue.performOnMain({
                        completion(result, nil)
                    })
            }
        } catch {
            DispatchQueue.performOnMain({
                completion(nil, error)
            })
        }
    }
    
    
    // MARK: - Public Actions
    
    func paginatorOfApps() -> Paginator<App> {
        let paginator: Paginator<App> = Paginator(baseURL: URL(string: "rss/topfreeapplications/",
                                                               relativeTo: baseURL)!,
                                                  fieldName: "entry")
        paginator.limit = 10
        paginator.fetcher = self
        return paginator
    }
    
    func grossingApps(completion: @escaping ([App], Error?) -> Void) {
        do {
            try get(URL(string: "rss/topgrossingapplications/limit=10/json",
                        relativeTo: baseURL)!.absoluteString.urlQueryEncoded, parameters: nil) { [weak self] (object, error) in
                            guard error == nil else {
                                completion([], error!)
                                return
                            }
                            
                            guard let results = ((object as? JSONObject)?["feed"] as? JSONObject)?["entry"] as? [JSONObject] else {
                                // create new error
                                
                                DispatchQueue.performOnMain({
                                    completion([], error)
                                })
                                
                                return
                            }
                            
                            var apps = [App]()
                            
                            for jsonObject in results {
                                guard let app = App.from(jsonObject: jsonObject) else {
                                    continue
                                }
                                
                                apps.append(app)
                            }
                            
                            self?.updateAppDetails(apps, completion: { (apps, error) in
                                guard error == nil else {
                                    DispatchQueue.performOnMain({
                                        completion([], error)
                                    })
                                    
                                    return
                                }
                                
                                DispatchQueue.performOnMain({
                                    completion(apps, nil)
                                })
                            })
            }
        } catch {
            DispatchQueue.performOnMain({
                completion([], error)
            })
        }
    }
    
    func updateAppDetails(_ apps: [App], completion: @escaping ([App], Error?) -> Void) {
        var result = [App]()
        
        let group = DispatchGroup()
        
        for var app in apps {
            group.enter()
            fetchAppDetails(of: app.identifier, completion: { (jsonObject, error) in
                guard let jsonObject = jsonObject,
                    error == nil else {
                        // new error
                        completion([], error)
                        
                        return
                }
                
                let detail = App.Detail.from(jsonObject: jsonObject)
                app.detail = detail
                
                result.append(app)
                
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(result, nil)
        }
    }
}
