//
//  AppDelegate.swift
//  ScratchTraxApp2
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let url = Bundle.main.url(forResource: "Theme", withExtension: "plist"),
           let data = NSDictionary(contentsOf: url) as? [String: Any] {
            UserDefaults.standard.set(data, forKey: "Theme")
        }
        return true
    }

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
}

public extension UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        applyBrandedFont()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        applyBrandedFont()
    }
    
    private func applyBrandedFont() {
        guard let theme = UserDefaults.standard.dictionary(forKey: "Theme"),
              let name = theme["bodyFontName"] as? String,
              let size = theme["bodyFontSize"] as? CGFloat else { return }
        
        self.font = UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
        
        if let colorName = theme["bodyFontColor"] as? String {
            self.textColor = UIColor(namedSystemOrHex: colorName) ?? .darkGray
        }
    }
}

extension UIColor {
    convenience init?(namedSystemOrHex name: String?) {
        guard let name = name else { return nil }
        
        let systemColors: [String: UIColor] = [
            "systemred": .systemRed,
            "systemblue": .systemBlue,
            "systemteal": .systemTeal,
            "systemgray": .systemGray,
            "white": .white,
            "black": .black,
            "darkGray": .darkGray,
            "lightGray": .lightGray
        ]
        if let color = systemColors[name.lowercased()] {
            self.init(cgColor: color.cgColor)
            return
        }
        
        // Hex format: #RRGGBB
        if name.hasPrefix("#"), name.count == 7 {
            let r = CGFloat(Int(name.dropFirst().prefix(2), radix: 16) ?? 0) / 255.0
            let g = CGFloat(Int(name.dropFirst(3).prefix(2), radix: 16) ?? 0) / 255.0
            let b = CGFloat(Int(name.dropFirst(5).prefix(2), radix: 16) ?? 0) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
            return
        }
        
        return nil
    }
}

public extension UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        applyBrandedFont()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        applyBrandedFont()
    }
    
    private func applyBrandedFont() {
        guard let theme = UserDefaults.standard.dictionary(forKey: "Theme"),
              let name = theme["titleFontName"] as? String,
              let size = theme["titleFontSize"] as? CGFloat else { return }
        
        var config = UIButton.Configuration.filled()
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var newAttrs = attrs
            newAttrs.font = UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
            return newAttrs
        }
        
        config.baseBackgroundColor = UIColor(namedSystemOrHex: theme["buttonBaseBackgroundColor"] as? String) ?? .systemTeal
        config.baseForegroundColor = UIColor(namedSystemOrHex: theme["buttonBaseForegroundColor"] as? String) ?? .white
        config.background.cornerRadius = theme["buttonCornerRadius"] as? CGFloat ?? 12
        config.background.strokeColor = UIColor(namedSystemOrHex: theme["buttonStrokeColor"] as? String) ?? .white
        config.background.strokeWidth = theme["buttonStrokeWidth"] as? CGFloat ?? 2
        
        self.configuration = config
        
        self.configurationUpdateHandler = { button in
            var updated = button.configuration ?? UIButton.Configuration.filled()
            
            if button.isHighlighted {
                updated.baseBackgroundColor = UIColor(namedSystemOrHex: theme["buttonHighlightedColor"] as? String) ?? .systemRed
            } else if !button.isEnabled {
                updated.baseBackgroundColor = UIColor(namedSystemOrHex: theme["buttonDisabledColor"] as? String) ?? .systemGray
            } else {
                updated.baseBackgroundColor = UIColor(namedSystemOrHex: theme["buttonBaseBackgroundColor"] as? String) ?? .systemTeal
            }
            
            button.configuration = updated
        }
    }
}
