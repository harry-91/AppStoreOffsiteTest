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
    
    
    fileprivate var grossingApps = [App]()
    fileprivate var apps = [App]()
    
    fileprivate var storedGrossingApps = [App]()
    fileprivate var storedApps = [App]()

    
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
            self?.userInterface?.reloadRows(at: [IndexPath(row: 0,
                                                           section: 0)])
        })
    }
    
    func loadMoreApps() {
        interactor?.loadMoreApps(completion: { [weak self] (moreApps, error) in
            guard error == nil, let this = self else {
                return
            }
            
            
            let count = this.apps.count
            this.apps.append(contentsOf: moreApps)
            
            var indexPathes = [IndexPath]()
            for index in count ..< (count + moreApps.count) {
                indexPathes.append(IndexPath(row: index,
                                             section: 1))
            }
            this.userInterface?.performUpdates(at: indexPathes)
            
            if this.apps.count == 100 {
                this.userInterface?.disableInfiniteScrolling()
            }
        })
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
    
    
    // MARK: - Searching
    
    func search(with keyword: String) {
        defer {
            userInterface?.reloadData()
        }
        
        guard keyword != "" else {
            apps.removeAll()
            grossingApps.removeAll()
            
            apps.append(contentsOf: storedApps)
            grossingApps.append(contentsOf: storedGrossingApps)
            
            return
        }
        
        let keyword = keyword.lowercased()
        let filteredGrossingApps = storedGrossingApps.filter { $0.artist.lowercased().contains(keyword) ||
            $0.category.lowercased().contains(keyword) ||
            $0.name.lowercased().contains(keyword) ||
            $0.summary.lowercased().contains(keyword) }
        let filteredApps = storedApps.filter { $0.artist.lowercased().contains(keyword) ||
            $0.category.lowercased().contains(keyword) ||
            $0.name.lowercased().contains(keyword) ||
            $0.summary.lowercased().contains(keyword) }
        
        grossingApps = filteredGrossingApps
        apps = filteredApps
    }
    
    func searchBarTextDidBeginEditing() {
        userInterface?.disableInfiniteScrolling()
        
        storedApps.removeAll()
        storedGrossingApps.removeAll()
        
        storedApps.append(contentsOf: apps)
        storedGrossingApps.append(contentsOf: grossingApps)
    }
    
    func searchBarTextDidEndEditing() {
        apps.removeAll()
        grossingApps.removeAll()
        
        apps.append(contentsOf: storedApps)
        grossingApps.append(contentsOf: storedGrossingApps)
        
        storedApps.removeAll()
        storedGrossingApps.removeAll()
        
        userInterface?.reloadData()
        
        userInterface?.enableInfiniteScrolling()
    }
}
