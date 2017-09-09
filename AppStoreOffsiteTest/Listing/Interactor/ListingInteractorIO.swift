//
//  ListingInteractorIO.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

protocol ListingInteractorInterface: class {
    func findApps(completion: @escaping ([App], Error?) -> ())
    func findGrossingApps(completion: @escaping ([App], Error?) -> ())
    func loadMoreApps(completion: @escaping ([App], Error?) -> ())
}
