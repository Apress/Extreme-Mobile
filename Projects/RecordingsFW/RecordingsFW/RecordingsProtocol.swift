//
//  RecordingsProtocol.swift
//  RecordingsFW
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
    func instantiateRootViewController() -> UIViewController
}

public class RecordingsProtocol: DisplayableViewController {
    public init() {}
    
    public func instantiateRootViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "RecordingsUI", bundle: Bundle(for: RecordingsTVC.self))
        let vc = storyboard.instantiateViewController(withIdentifier: "RecordingsNC")
        return vc
    }
}

protocol RefreshableViewModel {
    func getRecordings() -> [Recording]
    func refresh()
}

struct Recording: Codable {
    let bitrate: Int64
    let copyright: String
    let date: String
    let length: Int64
    let size: Int64
    var title: String
    let type: String
    let url: String
}

enum RecordingsEndpoint {
    case fetchRecordings
    var urlString: String {
        switch self {
        case .fetchRecordings:
            return "https://graphixware.free.beeceptor.com/scratchtrax/recordings"
        }
    }
}

enum RecordingsError: Error {
    case request(message: String)
    case network(message: String)
    case status(message: String)
    case parsing(message: String)
    case other(message: String)
}
