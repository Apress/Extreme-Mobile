//
//  SwiftDataManager.swift
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation
import SwiftData
import Combine

@Model
public final class Configuration {
    @Attribute(.unique) public var id: UUID
    public var publishRecordings: Bool
    public var trackCount: Int16
    
    public init(id: UUID = UUID(), publishRecordings: Bool = false, trackCount: Int16 = 0) {
        self.id = id
        self.publishRecordings = publishRecordings
        self.trackCount = trackCount
    }
}

public class SwiftDataManager: ObservableObject {
    public static let shared = SwiftDataManager()
    
    @Published public var configuration: Configuration?
    
    private let modelContainer: ModelContainer
    private let context: ModelContext
    
    private init() {
        do {
            // Correct initialization of ModelContainer
            modelContainer = try ModelContainer(for: Configuration.self)
            context = ModelContext(modelContainer)
            
            fetchConfiguration()
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    public func fetchConfiguration() {
        let fetchDescriptor = FetchDescriptor<Configuration>()
        do {
            if let firstConfig = try context.fetch(fetchDescriptor).first {
                self.configuration = firstConfig
            }
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    public func saveConfiguration(existing: Configuration? = nil, publishRecordings: Bool, trackCount: Int16) {
        let config: Configuration
        if let existing = existing {
            config = existing
        } else {
            config = Configuration()
            context.insert(config)
        }
        
        config.publishRecordings = publishRecordings
        config.trackCount = trackCount
        
        do {
            try context.save()
            self.configuration = config
        } catch {
            print("Save failed: \(error)")
        }
    }
}
