//
//  SceneDelegate.swift
//  ScratchTraxApp2
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import UIKit
import SettingsFW

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        
        if let storyboard = session.configuration.storyboard {
            if let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController {
                window = UIWindow(windowScene: winScene)
                window?.rootViewController = tabBarController
                window?.makeKeyAndVisible()
                
                var tbcViewControllers = tabBarController.viewControllers ?? []
                
                // Add framework UI's generically...
                if let configs = UserDefaults.standard.object(forKey: "views") as? [[String:String]] {
                    var lastTitle = ""
                    
                    for config in configs {
                        if let bundle = config["bundle"], let storyboard = config["storyboard"], let view = config["view"] {
                            if let bundle = Bundle(identifier: bundle) {
                                let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
                                let storyboardVC = storyboard.instantiateViewController(withIdentifier: view)
                                
                                var image: UIImage?
                                
                                if let icon = config["icon"] {
                                    image = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
                                }
                                
                                storyboardVC.tabBarItem = UITabBarItem(title: config["title"], image: image, tag: 0)
                                
                                // Since frameworks are loaded in an arbitrary order which cannot be controlled, add them
                                // to the tab bar in alphabetical order...
                                if lastTitle == "" || storyboardVC.tabBarItem.title?.caseInsensitiveCompare(lastTitle) == .orderedDescending {
                                    tbcViewControllers.append(storyboardVC)
                                } else {
                                    tbcViewControllers.insert(storyboardVC, at: tabBarController.viewControllers?.count ?? 0)
                                }
                                
                                lastTitle = storyboardVC.tabBarItem.title ?? ""
                            }
                        }
                    }
                    
                    // Add framework UI's via protocol...
                    tbcViewControllers.append(SettingsProtocol().instantiateRootViewController(configuration: ["Test" : true]))
                    
                    tabBarController.setViewControllers(tbcViewControllers, animated: false)
                }
            }
        }
        
        // Override any frameworks’ p-list settings with its own…
        if let bundle = Bundle(identifier:"com.gw.ScratchTraxApp2"), let path = bundle.path(forResource: "ScratchTraxApp2", ofType: "plist"),
            let plistDict = NSDictionary(contentsOfFile: path), let showPublished = plistDict["showPublished"] as? Bool {
            var features = UserDefaults.standard.object(forKey: "features") as? [String:String] ?? [:]
            features["showPublished"] = String(showPublished)
            UserDefaults.standard.set(features, forKey: "features")
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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


}

