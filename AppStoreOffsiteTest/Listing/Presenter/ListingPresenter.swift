//
//  ListingPresenter.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

class ListingPresenter: ListingModuleInterface {

    weak var userInterface: ListingViewInterface?
    var wireframe: ListingWireframe?
    
    var interactor: ListingInteractorInterface?
    
    
    fileprivate var grossingApps = [App]() {
        didSet {
            userInterface?.reloadRows(at: [IndexPath(row: 0,
                                                     section: 0)])
        }
    }
    fileprivate var apps = [App]()
    
    // MARK: - ListingModuleInterface
    
    func updateApps() {
        interactor?.findApps(completion: { [weak self] (apps, error) in
            guard error == nil else {
                return
            }
            
            self?.apps = apps
            
            self?.userInterface?.reloadData()
        })
    }
    
    func updateGrossingApps() {
        interactor?.findGrossingApps(completion: { [weak self] (apps, error) in
            guard error == nil else {
                return
            }
            
            self?.grossingApps = apps
        })
    }
    
    func loadMoreApps() {
//        interactor?.loadMoreApps(completion: { (moreApps, error) in
//            guard error == nil else {
//                return
//            }
//            
//            apps.append(contentsOf: moreApps)
//        })
    }
    
    
    func numberOfSections() -> Int {
        return 2
    }
    func numberOfRows(in section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return apps.count
    }
    
    func cellForRow(at indexPath: IndexPath, for tableView: UITableView) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationTableViewCell",
                                                     for: indexPath) as! RecommendationTableViewCell
            
            cell.grossingApps = grossingApps
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell",
                                                     for: indexPath) as! ListingTableViewCell
            cell.number = indexPath.row + 1
            cell.app = apps[indexPath.row]
            
            return cell
        }
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 180
        case 1:
            return 100
            
        default:
            return UITableViewAutomaticDimension
        }
    }
    func titleForHeader(in section: Int) -> String? {
        if section == 0 {
            return "Recommendation"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
