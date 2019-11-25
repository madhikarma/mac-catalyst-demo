//
//  AlbumDetailViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 25/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit
import ImageManager

 
class AlbumView: UIView {
    
    let imageView = UIImageView()
    let label = UILabel()

    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(imageView)
        addSubview(label)
    }
    
    private func setupConstraints() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

    }
}
class AlbumViewController: UIViewController {
    
    private let album: Album
    var index: Int = 0
    
    init(album: Album) {
        self.album = album
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
        view.backgroundColor = (index%2 == 0) ? .red : .purple
        let albumView = (view as! AlbumView)
        albumView.label.text = album.albumName
        navigationItem.title = album.albumName
        
        guard let imageURL = album.albumImageURL else { return }
        ImageManager().loadImage(for: imageURL, completion: { (result) in
            switch result {
            case .success(let image):
                albumView.imageView.image = image
            case .failure(_):
                albumView.imageView.image = nil
            }
        })
    }
}


final class AlbumScrollViewController: UIPageViewController {
    
    private var orderedViewControllers: [AlbumViewController] = []
    private(set) var albums: [Album] = []
    
    init(albums: [Album]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.albums = albums
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        dataSource = self

        view.backgroundColor = .brown
        
        for (index, album) in albums.enumerated() {
            let vc = AlbumViewController(album: album)
            vc.index = index
            orderedViewControllers.append(vc)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancel))
        setViewControllers([orderedViewControllers.first!], direction: .forward, animated: false, completion: nil)
    }
    
    
    // MARK: - Actions
    
    @objc func didPressCancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UIPageViewControllerDataSource

extension AlbumScrollViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! AlbumViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! AlbumViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
}


// MARK: - UIPageViewControllerDelegate

extension AlbumScrollViewController: UIPageViewControllerDelegate {
    
    
}
