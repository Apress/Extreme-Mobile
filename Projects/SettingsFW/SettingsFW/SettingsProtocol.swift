//
//  SettingsProtocol.swift
//  SettingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation
import UIKit

protocol DisplayableViewController {
    func instantiateRootViewController(configuration: Dictionary<String, Any>) -> UIViewController
}

public class SettingsProtocol: DisplayableViewController {
    public init() {}
    
    public func instantiateRootViewController(configuration: Dictionary<String, Any>) -> UIViewController {
        let storyboard = UIStoryboard(name: "SettingsUI", bundle: Bundle(for: SettingsTVC.self))
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsNC")
        
        if let navController = vc as? UINavigationController {
            if let settingsTVC = navController.topViewController as? SettingsTVC {
                settingsTVC.configure(configuration: configuration)
            }
        }
        
        return vc
    }
}
