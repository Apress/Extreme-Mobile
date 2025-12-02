//
//  ThemeEnvironment.swift
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import SwiftUI

private struct AppBodyFontKey: EnvironmentKey {
    static let defaultValue: Font = .body
}

private struct AppButtonFontKey: EnvironmentKey {
    static let defaultValue: Font = .headline
}

public extension EnvironmentValues {
    var appBodyFont: Font {
        get { self[AppBodyFontKey.self] }
        set { self[AppBodyFontKey.self] = newValue }
    }
    
    var appButtonFont: Font {
        get { self[AppButtonFontKey.self] }
        set { self[AppButtonFontKey.self] = newValue }
    }
}

public extension View {
    /// Applies theme-based fonts from UserDefaults to the environment.
    func applyThemeEnvironment() -> some View {
        let theme = UserDefaults.standard.dictionary(forKey: "Theme")
        
        let bodyFont: Font = {
            if let name = theme?["bodyFontName"] as? String,
               let size = theme?["bodyFontSize"] as? CGFloat {
                return Font.custom(name, size: size, relativeTo: .body)
            }
            return .body
        }()
        
        let buttonFont: Font = {
            if let name = theme?["titleFontName"] as? String,
               let size = theme?["titleFontSize"] as? CGFloat {
                return Font.custom(name, size: size, relativeTo: .headline)
            }
            return .headline
        }()
        
        return self
            .environment(\.appBodyFont, bodyFont)
            .environment(\.appButtonFont, buttonFont)
    }
}
