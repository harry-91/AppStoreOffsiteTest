//
//  AppDependencies.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

class AppDependencies {
    
    static let shared = AppDependencies()
    
    let listingWireframe = ListingWireframe()
    
    func installRootViewControllerIntoWindow(_ window: UIWindow) {
        let viewController = ListingWireframe.instantiateListingTableViewController(listingWireframe)
        listingWireframe.viewController = viewController
        window.rootViewController = UINavigationController(rootViewController: viewController)
    }
}

