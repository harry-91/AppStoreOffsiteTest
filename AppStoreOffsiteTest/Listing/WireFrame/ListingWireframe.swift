//
//  ListingWireframe.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

class ListingWireframe: Wireframe {
    
    override class var storyboardName: String { return "Listing" }
    
    // MARK: - Load view controller
    
    class func instantiateListingTableViewController(_ wireframe: ListingWireframe) -> ListingTableViewController  {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ListingTableViewController") as! ListingTableViewController
        let presenter = ListingPresenter()
        let interactor = ListingInteractor()
        
        // view linking
        viewController.eventHandler = presenter
        presenter.userInterface = viewController
        
        // interactors linking
        presenter.interactor = interactor
        
        // wireframe linking
        presenter.wireframe = wireframe
        wireframe.viewController = viewController
        
        return viewController
    }
}
