//
//  RecordingStudioProtocol.swift
//  RecordingStudioFW
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
    func instantiateRootViewController()-> UIViewController
}

public class RecordingStudioProtocol: DisplayableViewController {
    public init() {}
    
    public func instantiateRootViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "RecordingStudioUI", bundle: Bundle(for: RecordingStudioProtocol.self))
        let vc = storyboard.instantiateViewController(withIdentifier: "RecordingStudioNC")
        return vc
    }
}
