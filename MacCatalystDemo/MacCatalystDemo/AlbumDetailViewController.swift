//
//  AlbumDetailViewController.swift
//  MacCatalystDemo
//
//  Created by Beta on 25/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit

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
        self.view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = (index%2 == 0) ? .red : .purple
        
        let label = UILabel(frame: .zero)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        label.text = album.albumName
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
