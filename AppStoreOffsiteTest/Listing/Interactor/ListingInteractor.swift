//
//  ListingInteractor.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

class ListingInteractor: ListingInteractorInterface {
    fileprivate let paginator = AppStoreAPIClient.shared.paginatorOfApps()
    
    func findApps(completion: @escaping ([App], Error?) -> ()) {
        paginator.fetchNext { (apps, error) in
            guard error == nil else {
                DispatchQueue.performOnMain({ 
                    completion([], error)
                })
                
                return
            }
            
            AppStoreAPIClient.shared.updateAppDetails(apps, completion: { (apps, error) in
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

    }
    
    
    func findGrossingApps(completion: @escaping ([App], Error?) -> ()) {
        AppStoreAPIClient.shared.grossingApps { (apps, error) in
            guard error == nil else {
                completion([], error)
                
                return
            }
            
            completion(apps, nil)
        }
    }
    
    
    func loadMoreApps(completion: @escaping ([App], Error?) -> ()) {
    }
}

