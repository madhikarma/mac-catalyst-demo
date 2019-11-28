//
//  AppDelegate.swift
//  MacCatalystDemo
//
//  Created by Beta on 19/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit
//import Cocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // DEMO 3
    
    override func buildMenu(with builder: UIMenuBuilder) {
        
        // First check if the builder object is using the main system menu, which is the main menu bar.
        // If you want to check if the builder is for a contextual menu, check for: UIMenuSystem.context
        
        guard builder.system == .main else { return }
        
        // we don't need `Format` menu in Main menu,
        // so let's remove it
        builder.remove(menu: .format)
                
        let addNoteCommand = UIKeyCommand(title: "New…",
                                      action: #selector(new),
                                      input: "f",
                                      modifierFlags: [.command, .alternate])
        let menu = UIMenu(title: "",
                          image: nil,
                          identifier: UIMenu.Identifier(""),
                          options: .displayInline,
                          children: [addNoteCommand])
        builder.insertChild(menu, atStartOfMenu: .file)
    }
    
    @objc
    func new() {
        print(#function)
    }
    
    // MARK: UISceneSession Lifecycle
/*
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
 */
}

