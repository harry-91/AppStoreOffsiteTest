//
//  ListingTableViewController.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit

class ListingTableViewController: UITableViewController {
    var eventHandler: ListingModuleInterface?
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        
        tableView.backgroundColor = .white

        eventHandler?.updateApps()
        eventHandler?.updateGrossingApps()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return eventHandler?.numberOfSections() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventHandler?.numberOfRows(in: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return eventHandler!.cellForRow(at: indexPath, for: tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return eventHandler?.heightForRow(at: indexPath) ?? UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventHandler?.titleForHeader(in: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        eventHandler?.tableView(tableView, didSelectRowAt: indexPath)
    }

}

extension ListingTableViewController: ListingViewInterface {
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadRows(at indexPathes: [IndexPath]) {
        tableView.reloadRows(at: indexPathes, with: .automatic)
    }
}
