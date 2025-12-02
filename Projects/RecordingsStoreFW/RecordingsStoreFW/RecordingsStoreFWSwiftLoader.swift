//
//  RecordingsStoreFWSwiftLoader.swift
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation

@objcMembers public class RecordingsStoreFWSwiftLoader: NSObject {
    override public init() {
        super.init()
        
        initViews()
        initFeatures()
    }
    
    func initViews() {
        let config = [ "bundle": "com.gw.RecordingsStoreFW", "storyboard": "RecordingsStoreUI", "view": "RecordingsStoreVC", "title": "Pro Features", "icon": "storefront"]
        
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
            if config["bundle"] == "com.gw.RecordingsStoreFW", config["storyboard"] == "RecordingsStoreUI", config["view"] == "RecordingsStoreVC" {
                found = true
                break
            }
        }
        
        return found
    }
    
    func initFeatures() {
        var publish = false
        var tracks: Int16 = 1
        
        let manager = SwiftDataManager.shared
        
        if let config = manager.configuration {
            publish = config.publishRecordings
            tracks = config.trackCount
        } else {
            // No existing configuration — create a default one
            manager.saveConfiguration(existing: nil, publishRecordings: false, trackCount: 1)
            if let config = manager.configuration {
                publish = config.publishRecordings
                tracks = config.trackCount
            }
        }
        
        UserDefaults.standard.set(["publishRecordings": publish, "trackCount": tracks], forKey: "features")
    }
}
