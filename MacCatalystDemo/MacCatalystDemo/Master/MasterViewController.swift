//
//  MasterViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 19/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit
import iTunesAPI

class MasterViewController: UITableViewController {

    var detailViewController: GridViewController? = nil
    var artists: [iTunesSearchResult] = []
    let searchAPI = iTunesSearchAPI()

    // MARK - View lifecycle
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? GridViewController
        }
        
        print("get results...")
        searchAPI.getResults(searchTerm: "Bonobo") { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let searchResults):
                print("success...")
                self.artists = searchResults
                print(searchResults)
                self.tableView.reloadData()
                self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            case .failure(let error):
                print("error...")
                print(error)
            }
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    
    // MARK: - Actions
    
    @objc
    func add(_ sender: Any) {
        let searchViewController = SearchViewController()
        present(searchViewController, animated: true, completion: nil)
    }

    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let artist = artists[indexPath.row]
        cell.textLabel?.text = artist.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = (splitViewController?.viewControllers[1] as! UINavigationController).topViewController as! GridViewController
        showDetail(indexPath: indexPath, detail: controller)
    }
    
    func showDetail(indexPath: IndexPath, detail controller: GridViewController) {
        let artist = artists[indexPath.row]
        print("before: \(String(describing: controller.artist))")
        controller.artist = artist
        print("after; \(String(describing: controller.artist))")
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
        detailViewController = controller
    }
}

