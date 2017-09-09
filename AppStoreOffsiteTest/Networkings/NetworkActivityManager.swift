//
//  NetworkActivityManager.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

public class NetworkActivityManager {
    
    fileprivate var jobsCount = 0 {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = jobsCount != 0
        }
    }
    
    fileprivate var executionQueue = DispatchQueue(label: "com.AppStoreOffsiteTest.NetworkActivityQueue")
    
    func increment() {
        executionQueue.async {
            self.jobsCount += 1
        }
    }
    
    func decrement() {
        executionQueue.async {
            self.jobsCount -= 1
        }
    }
    
}


public extension NetworkActivityManager {
    static var shared = NetworkActivityManager()
}
