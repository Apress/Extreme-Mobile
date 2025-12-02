//
//  RecordingStudioFWSwiftLoader.swift
//  RecordingStudioFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation

@objcMembers public class RecordingStudioFWSwiftLoader: NSObject {
    override public init() {
        super.init()
        
        initViews()
    }
    
    func initViews() {
        let config = [ "bundle": "com.gw.RecordingStudioFW", "storyboard": "RecordingStudioUI", "view": "RecordingStudioNC", "title": "Recording Studio", "icon": "music.note"]
        
        var configs: [[String:String]] = []
        
        if let persistedConfigs = UserDefaults.standard.object(forKey: "views") as? [Dictionary<String,String>], !persistedConfigs.isEmpty {
            configs.append(contentsOf: persistedConfigs)
            
            if !findConfig(configs: persistedConfigs) {
                configs.append(config)
            }
        } else {
            configs.append(config)
        }
        
        UserDefaults.standard.set(configs, forKey: "views")
    }
    
    func findConfig(configs: [[String:String]]) -> Bool {
        var found = false
        
        for config in configs {
            if config["bundle"] == "com.gw.RecordingStudioFW", config["storyboard"] == "RecordingStudioUI", config["view"] == "RecordingStudioNC" {
                found = true
                break
            }
        }
        
        return found
    }
}
