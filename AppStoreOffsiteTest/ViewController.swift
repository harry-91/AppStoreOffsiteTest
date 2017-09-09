//
//  ViewController.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 07/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let paginator = AppStoreAPIClient.shared.paginatorOfApps()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        
//        paginator.fetchNext { (apps, error) in
//            for var app in apps {
//                AppStoreAPIClient.shared.fetchAppDetails(of: app.identifier, completion: { (jsonObject, error) in
//                    guard let jsonObject = jsonObject,
//                        error == nil else {
//                        return
//                    }
//                    
//                    let detail = App.Detail.from(jsonObject: jsonObject)
//                    app.detail = detail
//                })
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

