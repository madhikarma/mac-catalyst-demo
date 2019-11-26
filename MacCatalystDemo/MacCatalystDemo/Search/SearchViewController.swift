//
//  SearchViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 26/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit

let cellIdentifier = "searchResultsCellIdentifier"

struct Footballer {
  var name: String
  var league: String
}

let allPlayers = [
  Footballer(name: "Ronaldo", league: "Seria A"),
  Footballer(name: "Messi", league: "La liga"),
  Footballer(name: "Ozil", league: "Premier League"),
  Footballer(name: "Rooney", league: "MLS"),
  Footballer(name: "Neymar", league: "Ligue One"),
  Footballer(name: "Cavani", league: "Ligue One"),
  Footballer(name: "Dybala", league: "Seria A"),
  Footballer(name: "Robben", league: "Bundesliga"),
  Footballer(name: "James", league: "Bundesliga"),
  Footballer(name: "Lukaku", league: "Premier League"),
  Footballer(name: "Kane", league: "Premier League"),
  Footballer(name: "Cech", league: "Premier League"),
  Footballer(name: "Pogba", league: "Premier League"),
  Footballer(name: "Bale", league: "La liga")
]


class SearchViewController: UIViewController {

    private let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFootballer = [Footballer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = .red
        
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
    
    fileprivate func filterFootballers(for searchText: String) {
      filteredFootballer = allPlayers.filter { footballer in
        return
          footballer.name.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }

}


// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if searchController.isActive && searchController.searchBar.text != "" {
        return filteredFootballer.count
      }
      return allPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
      
      let footballer: Footballer
      if searchController.isActive && searchController.searchBar.text != "" {
        footballer = filteredFootballer[indexPath.row]
      } else {
        footballer = allPlayers[indexPath.row]
      }
      
      cell.textLabel?.text = footballer.name
      cell.detailTextLabel?.text = footballer.league
      return cell
    }
}


// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterFootballers(for: searchController.searchBar.text ?? "")
    }
}
