//
//  Wireframe.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

internal class Wireframe {
    class var storyboardName: String { return "" }
    class var storyboard: UIStoryboard? {
        guard self.storyboardName.isEmpty == false else {
            return nil
        }
        return UIStoryboard(name: self.storyboardName, bundle: Bundle.main)
    }
    
    weak var viewController: UIViewController?
    
    // MARK: - navigation control
    
    func push(wireframe: Wireframe, viewController: UIViewController, animated: Bool = true, completion: (() -> ())? = nil) {
        wireframe.viewController = viewController
        
        DispatchQueue.main.async { [weak self] in
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            self?.viewController?.navigationController?.pushViewController(viewController, animated: animated)
            CATransaction.commit()
        }
    }
}
