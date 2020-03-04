//
//  ListingTableViewController.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import UIKit
import SVPullToRefresh

class ListingTableViewController: UITableViewController {
    var eventHandler: ListingModuleInterface?
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "SEARCH"
        searchBar.delegate = self
        
        return searchBar
    }()
    fileprivate var isCancelButtonClicked = false
    fileprivate lazy var loadingView: LoadingPlaceholderView = {
        let loadingView = LoadingPlaceholderView(frame: self.tableView.bounds)
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return loadingView
    }()
    fileprivate lazy var emptyView: EmptyPlaceholderView = {
        let emptyView = EmptyPlaceholderView(frame: self.tableView.bounds)
        emptyView.backgroundColor = .white
        emptyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        emptyView.title = "No Result"
        emptyView.isHidden = true
        
        self.tableView.addSubview(emptyView)
        
        return emptyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()

        eventHandler?.updateApps()
        eventHandler?.updateGrossingApps()
        
        tableView.addInfiniteScrolling { [weak self] in
            self?.eventHandler?.loadMoreApps()
        }
        
        tableView.addSubview(loadingView)
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
        return eventHandler?.heightForRow(at: indexPath) ?? UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()
        
        eventHandler?.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 70
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return eventHandler?.viewForHeader(in: section)
    }

}


// MARK: - ListingViewInterface

extension ListingTableViewController: ListingViewInterface {
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadRows(at indexPathes: [IndexPath]) {
        tableView.reloadRows(at: indexPathes, with: .automatic)
    }
    
    func performUpdates(at indexPathes: [IndexPath]) {
        defer {
            tableView.infiniteScrollingView.stopAnimating()
        }
        
        guard indexPathes.count > 0 else {
            tableView.showsInfiniteScrolling = false
            
            return
        }
        
        tableView.beginUpdates()
        
        tableView.insertRows(at: indexPathes,
                             with: .bottom)
        
        tableView.endUpdates()
    }
    
    func disableInfiniteScrolling() {
        tableView.showsInfiniteScrolling = false
    }
    
    func enableInfiniteScrolling() {
        tableView.showsInfiniteScrolling = true
    }
    
    func hideLoading() {
        loadingView.isHidden = true
    }
    
    func showNoResultView() {
        emptyView.isHidden = false
    }
    
    func hideNoResultView() {
        emptyView.isHidden = true
    }
}


// MARK: - UISearchBarDelegate

extension ListingTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        eventHandler?.search(with: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard searchBar.text == "" else {
            return
        }
        
        eventHandler?.searchBarTextDidBeginEditing()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard searchBar.text == "" else {
            return
        }
        
        eventHandler?.searchBarTextDidEndEditing()
    }
}
