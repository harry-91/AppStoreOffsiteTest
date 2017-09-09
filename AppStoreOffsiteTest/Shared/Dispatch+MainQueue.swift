//
//  Dispatch+MainQueue.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

extension DispatchQueue {
    class func performOnMain(_ block: (() -> Void)?) {
        guard let block = block else {
            return
        }
        
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}

