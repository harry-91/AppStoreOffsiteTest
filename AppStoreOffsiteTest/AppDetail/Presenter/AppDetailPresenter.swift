//
//  AppDetailPresenter.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 10/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

class AppDetailPresenter: AppDetailModuleInterface {
    
    weak var userInterface: AppDetailViewInterface?
    var wireframe: AppDetailWireframe?
    
    var interactor: AppDetailInteractorInterface?
    
    var app: App?
    
    
    func viewDidLoad() {
        guard let app = app else { return }
        
        userInterface?.update(app: app)
    }
}
