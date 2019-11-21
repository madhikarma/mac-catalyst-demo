//
//  GridViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 19/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit
import iTunesAPI
import ImageManager

private let reuseIdentifier = "GridCollectionViewCell"

class GridViewController: UICollectionViewController {

    let imageManager = ImageManager()
    let itunesAPI = iTunesSearchAPI()
    var artist: iTunesSearchResult? {
        didSet {
            print("didSetArtist")
            if let id = artist?.id {
                print("artist")
                itunesAPI.lookup(id: id, parameters: ["entity": "album"]) { (result) in
                    switch result {
                    case .success(let values):
                        self.albums = values
                        self.configureView()
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                print("no artist")
            }
        }
    }
    private(set) var albums: [Album] = []
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "GridCollectionViewCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: "GridCollectionViewCell")
    }
    
    private func configureView() {
        collectionView.reloadData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as? GridCollectionViewCell else {
            fatalError("Error: expected GridCollectionViewCell")
        }
    
        // Configure the cell
        let album = albums[indexPath.row]
        print(album)
        
        cell.titleLabel?.text = album.albumName
        if let imageURL = album.albumImageURL {
            imageManager.loadImage(for: imageURL) { [unowned self] (result) in
                switch (result) {
                case .success(let image):
                    cell.imageView.image = image
                case .failure(let error):
                    cell.imageView.image = nil
                    print()
                }
            }
        }
        cell.contentView.backgroundColor = .blue
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
