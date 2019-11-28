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

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showSearch))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? GridViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    
    // MARK: - Actions
    
    @objc
    func showSearch() {
        // DEMO 4
        let searchViewController = SearchViewController()
        searchViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: searchViewController)
      //  navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true, completion: nil)
    }
        
    
    // MARK: - Navigation
    
    fileprivate func showDetail(indexPath: IndexPath, detail controller: GridViewController) {
        let artist = artists[indexPath.row]
        controller.artist = artist
        detailViewController = controller
    }
    
    
    // MARK: - UITableViewDataSource
    
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
}


// MARK: - SearchViewControllerDelegate

extension MasterViewController: SearchViewControllerDelegate {
    
    func searchViewControllerDidPressCancel(_ controller: SearchViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchViewControllerDidSelectResult(_ controller: SearchViewController, result: iTunesSearchResult) {
        artists.append(result)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
