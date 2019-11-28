//
//  SearchViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 26/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit
import iTunesAPI

protocol SearchViewControllerDelegate: class {
    func searchViewControllerDidSelectResult(_ controller: SearchViewController, result: iTunesSearchResult)
    func searchViewControllerDidPressCancel(_ controller: SearchViewController)
}

class SearchResultCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .blue
    }
}
final class SearchViewController: UIViewController {

    fileprivate let tableView = UITableView()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let searchAPI = iTunesSearchAPI()
    fileprivate var searchResults: [iTunesSearchResult] = []
    fileprivate var pendingSearchTasks: [URLSessionTask] = []
    weak var delegate: SearchViewControllerDelegate?
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        print("\(#function)")
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Type to search for your artist to add"
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        view.addSubview(tableView)
        
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
//        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancel))
    }
    
    @objc func didPressCancel() {
        delegate?.searchViewControllerDidPressCancel(self)
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("\(#function)")
//        searchController.dismiss(animated: true, completion: nil)
//        searchController.isActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(#function)")
        searchResults.removeAll()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\(#function)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = "\(searchResult.artistName) (id: \(searchResult.artistId))"
      return cell
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(#function)")
//        searchController.dismiss(animated: false, completion: nil)
        let result = searchResults[indexPath.row]
        delegate?.searchViewControllerDidSelectResult(self, result: result)
    }
}


// MARK: - UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("\(#function)")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("\(#function)")
    }
}


// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("\(#function)")
        
        guard searchController.isActive else {
            print("return search is inactive")
            return
        }
        
        guard let searchBarText = searchController.searchBar.text, searchBarText.count > 0 else {
            print("return search has nil or empty text")
            self.tableView.reloadData()
            return
        }
        
        print("Cancelling pending requests...")
        pendingSearchTasks.forEach { (task) in
            print("cancel")
            task.cancel()
        }
        
        let searchTask = searchAPI.getResults(searchTerm: searchBarText, parameters: ["entity": "allArtist", "attribute": "allArtistTerm"]) { [weak self] (result) in
            guard let self = self else { return }
            if let previous = self.pendingSearchTasks.last {
                print("removing last search")
                self.pendingSearchTasks = self.pendingSearchTasks.filter {$0 != previous }
            }
            
            print("completed")
            switch (result) {
            case .success(let results):
                print("success")
                self.searchResults = results
            case .failure(let error):
                print("failure \(error)")
                self.searchResults.removeAll()
            }
            print("pending searches count: \(self.pendingSearchTasks.count)")
            print("search results count: \(self.searchResults.count)")

            self.tableView.reloadData()
        }
        pendingSearchTasks.append(searchTask)
    }
}
