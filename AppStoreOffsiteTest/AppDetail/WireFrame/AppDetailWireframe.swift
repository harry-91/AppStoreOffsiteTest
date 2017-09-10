//
//  AppDetailWireframe.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 10/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

class AppDetailWireframe: Wireframe {
    
    override class var storyboardName: String { return "AppDetail" }
    
    // MARK: - Load view controller
    
    class func instantiateAppDetailViewController(_ wireframe: AppDetailWireframe, with app: App) -> AppDetailViewController  {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AppDetailViewController") as! AppDetailViewController
        let presenter = AppDetailPresenter()
        let interactor = AppDetailInteractor()
        
        // view linking
        viewController.eventHandler = presenter
        presenter.userInterface = viewController
        
        // interactors linking
        presenter.interactor = interactor
        
        // wireframe linking
        presenter.wireframe = wireframe
        wireframe.viewController = viewController
        
        // Others
        presenter.app = app
        
        return viewController
    }
}
