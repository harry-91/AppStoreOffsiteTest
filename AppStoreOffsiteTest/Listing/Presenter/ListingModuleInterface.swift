//
//  ListingModuleInterface.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

protocol ListingModuleInterface {
    func updateApps()
    func updateGrossingApps()
    
    func loadMoreApps()
    
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    
    func cellForRow(at indexPath: IndexPath, for tableView: UITableView) -> UITableViewCell
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func viewForHeader(in section: Int) -> UIView?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    func search(with keyword: String)
    func searchBarTextDidBeginEditing()
    func searchBarTextDidEndEditing()
}
