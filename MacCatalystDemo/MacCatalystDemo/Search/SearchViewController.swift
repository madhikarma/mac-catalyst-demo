//
//  SearchViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 26/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit
import iTunesAPI

let cellIdentifier = "searchResultsCellIdentifier"

class SearchViewController: UIViewController {

    fileprivate let tableView = UITableView()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let searchAPI = iTunesSearchAPI()
    fileprivate var searchResults: [iTunesSearchResult] = []
    fileprivate var pendingSearchTasks: [URLSessionTask] = []
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        
        //        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Type to search for your artist to add"
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}


// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
      let searchResult = searchResults[indexPath.row]
      cell.textLabel?.text = searchResult.artistName
      cell.detailTextLabel?.text = "\(searchResult.artistId)"
      return cell
    }
}


// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("updateSearchResults")
//        filterFootballers(for: searchController.searchBar.text ?? "")
        guard let searchBarText = searchController.searchBar.text else { return }
        
        pendingSearchTasks.forEach { $0.cancel() }
        let searchTask = searchAPI.getResults(searchTerm: searchBarText) { [weak self] (result) in
            guard let self = self else { return }
            switch (result) {
            case .success(let results):
                self.searchResults = results
            case .failure(let error):
                print(error)
                self.searchResults = []
            }
            self.tableView.reloadData()
        }
        pendingSearchTasks.append(searchTask)
        
    }
}
