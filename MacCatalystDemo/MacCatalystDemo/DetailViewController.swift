//
//  DetailViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 19/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // UI
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    // Model
    var artist: Artist? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    
    // MARK - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        detailDescriptionLabel?.text = artist?.name
    }
}

