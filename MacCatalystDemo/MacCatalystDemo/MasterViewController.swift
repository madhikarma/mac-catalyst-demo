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
    private(set) var artists: [Artist] = []
    let searchAPI = iTunesSearchAPI()

    // MARK - View lifecycle
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? GridViewController
        }
        
        print("get results...")
        searchAPI.getResults(searchTerm: "Bonobo") { (result) in
            switch result {
            case .success(let searchResults):
                print("success...")
                self.artists = searchResults
                print(searchResults)
                self.tableView.reloadData()
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

    @objc
    func insertNewObject(_ sender: Any) {
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let artist = artists[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! GridViewController
                controller.artist = artist
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
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
//
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            artists.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
}

