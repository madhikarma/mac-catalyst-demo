//
//  AlbumViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 25/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit
import ImageManager

class AlbumViewController: UIViewController {
    
    private let album: Album
    var index: Int = 0
    private let imageManager: ImageManager
    
    init(album: Album, imageManager: ImageManager) {
        self.album = album
        self.imageManager = imageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = AlbumView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Config.shared.isDebugColorsEnabled {
            view.backgroundColor = (index%2 == 0) ? .red : .purple
        }
        let albumView = (view as! AlbumView)
        albumView.label.text = album.albumName
        title = album.albumName
        
        guard let imageURL = album.albumImageURL else { return }
        imageManager.loadImage(for: imageURL, completion: { (result) in
            switch result {
            case .success(let image):
                albumView.imageView.image = image
            case .failure(_):
                albumView.imageView.image = nil
            }
        })
    }
}



