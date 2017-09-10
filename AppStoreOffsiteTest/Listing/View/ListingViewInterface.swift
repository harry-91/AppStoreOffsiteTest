//
//  ListingViewInterface.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

protocol ListingViewInterface: class {
    func reloadData()
    func reloadRows(at indexPathes: [IndexPath])
    func performUpdates(at indexPathes: [IndexPath])
    func disableInfiniteScrolling()
    func enableInfiniteScrolling()
    
    func hideLoading()
    func showNoResultView()
    func hideNoResultView()
}
