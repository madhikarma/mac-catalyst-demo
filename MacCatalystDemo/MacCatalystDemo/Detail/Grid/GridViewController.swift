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

class GridViewController: UIViewController {

    // UI
    private(set) var collectionView: UICollectionView!
    
    // Services
    private let imageManager = ImageManager()
    private let itunesAPI = iTunesSearchAPI()
    
    // Data
    private(set) var albums: [Album] = []
    var artist: iTunesSearchResult? {
        didSet {
            guard let id = artist?.id else { return }
            itunesAPI.lookup(id: id, parameters: ["entity": "album"]) { (result) in
                switch result {
                case .success(let values):
                    self.albums = values
                    self.configureView()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//        navigationItem.leftItemsSupplementBackButton = true

        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        let nib = UINib(nibName: "GridCollectionViewCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: "GridCollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        view.backgroundColor = .darkGray
        collectionView.backgroundColor = .darkGray
        let searchField = UISearchTextField(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 6, height: 44))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchField)
    }
    
    private func configureView() {
        collectionView.reloadData()
    }
    

    // MARK: - Actions
    
    // MacCatalystDemo[32430:891801] [Warning] -[UIApplication _hoverEventForWindow:]_block_invoke has no affect on this platform
    @objc
    func hovering(_ recognizer: UIHoverGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            UIView.animate(withDuration: 0.2) {
                recognizer.view?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
            }
        case .ended:
            UIView.animate(withDuration: 0.2) {
                recognizer.view?.backgroundColor = .clear
            }
        default:
            break
        }
    }

}


// MARK: UICollectionViewDataSource

extension GridViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as? GridCollectionViewCell else {
            fatalError("Error: expected GridCollectionViewCell")
        }
    
        // Configure the cell
        let album = albums[indexPath.row]
        cell.titleLabel?.text = album.albumName
        if let imageURL = album.albumImageURL {
            imageManager.loadImage(for: imageURL) { (result) in
                switch (result) {
                case .success(let image):
                    cell.imageView.image = image
                case .failure( _):
                    cell.imageView.image = nil
                    print()
                }
            }
        }
        // works on mac catalyst no op for iPad
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:)))
        cell.addGestureRecognizer(hover)
        return cell
    }
}



// MARK: - UICollectionViewDelegate

extension GridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelect")
        let viewController = AlbumScrollViewController(albums: albums, imageManager: imageManager)
        viewController.firstAlbumIndex = indexPath.row
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalTransitionStyle = .flipHorizontal
        self.present(navigationController, animated: true, completion: nil)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension GridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}


// MARK: - UICollectionViewDragDelegate

extension GridViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
    }

    
    /* If NO is returned no further delegate methods will be called for this drop session.
     * If not implemented, a default value of YES is assumed.
     */
//    optional func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
//
//    }

    
    /* Called when the drop session begins tracking in the collection view's coordinate space.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        print(#function)
    }

    
    /* Called frequently while the drop session being tracked inside the collection view's coordinate space.
     * When the drop is at the end of a section, the destination index path passed will be for a item that does not yet exist (equal
     * to the number of items in that section), where an inserted item would append to the end of the section.
     * The destination index path may be nil in some circumstances (e.g. when dragging over empty space where there are no cells).
     * Note that in some cases your proposal may not be allowed and the system will enforce a different proposal.
     * You may perform your own hit testing via -[UIDropSession locationInView]
     */
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//        print(#function)
//    }

    
    /* Called when the drop session is no longer being tracked inside the collection view's coordinate space.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        print(#function)
    }

    
    /* Called when the drop session completed, regardless of outcome. Useful for performing any cleanup.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        print(#function)
    }

    
    /* Allows customization of the preview used for the item being dropped.
     * If not implemented or if nil is returned, the entire cell will be used for the preview.
     *
     * This will be called as needed when animating drops via -[UICollectionViewDropCoordinator dropItem:toItemAtIndexPath:]
     * (to customize placeholder drops, please see UICollectionViewDropPlaceholder.previewParametersProvider)
     */
//    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//
//    }

}
