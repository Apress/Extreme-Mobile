//
//  RecordingsStoreVC.swift
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import SwiftUI
import UIKit

class RecordingsStoreVC: UIHostingController<AnyView> {
    required init?(coder: NSCoder) {
        let viewModel = IAPViewModel(
            service: IAPService.shared,
            endpoint: .fetchInAppPurchases
        )
        
        // Build the root view and apply environment values
        let view = RecordingsStoreView(viewModel: viewModel)
            .applyThemeEnvironment()
            .eraseToAnyView()
        
        super.init(coder: coder, rootView: view)
    }
}

private extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
