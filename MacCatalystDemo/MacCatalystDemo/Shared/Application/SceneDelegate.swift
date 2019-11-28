//
//  SceneDelegate.swift
//  MacCatalystDemo
//
//  Created by Beta on 19/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var master: MasterViewController? {
        guard let window = window else { return nil }
        guard let splitViewController = window.rootViewController as? UISplitViewController else { return nil}
        guard let navigationController = splitViewController.viewControllers.first as? UINavigationController else { return nil }
        return navigationController.topViewController as? MasterViewController
    }
    
    var detail: GridViewController? {
        guard let window = window else { return nil }
        guard let splitViewController = window.rootViewController as? UISplitViewController else { return nil }
        guard let navigationController = splitViewController.viewControllers.last as? UINavigationController else { return nil }
        return navigationController.topViewController as? GridViewController
    }
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("willConnectTo")
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let window = window else { return }
        guard let splitViewController = window.rootViewController as? UISplitViewController else { return }
        guard let navigationController = splitViewController.viewControllers.last as? UINavigationController else { return }
        navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
        splitViewController.preferredDisplayMode = .allVisible
        // Add a translucent background to the primary view controller.
        splitViewController.primaryBackgroundStyle = .sidebar
        splitViewController.delegate = self
        
        // DEMO 2
       /*
        #if targetEnvironment(macCatalyst)
            if let windowScene = scene as? UIWindowScene {
                if let titlebar = windowScene.titlebar {
                    let toolbar = NSToolbar(identifier: "myIdentifier")
                    toolbar.delegate = self
                    titlebar.toolbar = toolbar
                }
            }
        #endif
        */
    }
    
    @objc func new() {
        master!.showSearch()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        // DEMO 1
        
        var platform = ""
                
        #if targetEnvironment(macCatalyst)
            platform += "Catalyst\n"
        #endif
        
        #if os(macOS)
            platform += "macOS\n"
        #endif
        
        #if os(iOS)
            platform += "iOS\n"
        #endif
        
        let alert = UIAlertController(title: "Debug", message: platform, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        window!.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        print("collapseSecondary")
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? GridViewController else { return false }
        if topAsDetailController.artist == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}


#if targetEnvironment(macCatalyst)

let newToolbarItemId = NSToolbarItem.Identifier(rawValue: "newToolbarItemId")

extension SceneDelegate: NSToolbarDelegate {
    
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let item = NSToolbarItem(itemIdentifier: itemIdentifier)
        item.action = #selector(new)
        item.target = self
        item.image = UIImage(systemName: "airplayaudio")
        return item
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        print(#function)
        return [newToolbarItemId]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        print(#function)
        return [newToolbarItemId]
    }

    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        print(#function)
        return [newToolbarItemId]
    }

    func toolbarWillAddItem(_ notification: Notification) {
        print(#function)
    }

    func toolbarDidRemoveItem(_ notification: Notification) {
        print(#function)
    }
}
#endif
