//
//  RecordingsStoreView.swift
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import SwiftUI

struct RecordingsStoreView: View {
    @State private var selectedIAP: IAP?
    @State private var showAlert = false
    @State private var loaded = false
    @StateObject private var viewModel: IAPViewModel
    @StateObject private var dataManager = SwiftDataManager.shared
    
    init(viewModel: IAPViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selectedIAP) {
                ForEach(groupByCategory(viewModel.getIAPs()), id: \.0) { category in
                    IAPCategorySectionView(
                        category: category,
                        isPurchased: isPurchased,
                        selectAction: { iap in
                            selectedIAP = iap
                            showAlert = true
                        }
                    )
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("Add Features", displayMode: .large)
            .alert("Add Features", isPresented: $showAlert) {
                Button("OK") {
                    if let iap = selectedIAP {
                        updateFeatures(type: iap.type)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                AlertMessageText(message: "Do you want to purchase \"\(selectedIAP?.name ?? "?")\"")
            }
        }
        .onAppear {
            if !loaded {
                loaded = true
                viewModel.refresh()
            }
        }
    }
    
    private struct IAPRowView: View {
        let iap: IAP
        let isDisabled: Bool
        let action: () -> Void
        
        @Environment(\.appButtonFont) private var titleFont
        @Environment(\.appBodyFont) private var bodyFont
        
        var body: some View {
            HStack {
                Button(action: action) {
                    Text("\(Image(systemName: "music.note")) \(iap.name)")
                        .font(titleFont)
                }
                Spacer()
                Text(NumberFormatter.localizedString(from: NSNumber(value: iap.price), number: .currency))
                    .font(bodyFont)
            }
            .listRowSeparator(.hidden)
            .disabled(isDisabled)
        }
    }
    
    private struct IAPCategorySectionView: View {
        let category: (String, [IAP])
        let isPurchased: (IAP) -> Bool
        let selectAction: (IAP) -> Void
        
        @Environment(\.appButtonFont) private var titleFont
        
        var body: some View {
            Section(header: Text(category.0).font(titleFont)) {
                ForEach(category.1) { item in
                    IAPRowView(
                        iap: item,
                        isDisabled: isPurchased(item),
                        action: { selectAction(item) }
                    )
                }
            }
        }
    }
    
    private struct AlertMessageText: View {
        let message: String
        @Environment(\.appBodyFont) private var bodyFont
        
        var body: some View {
            Text(message)
                .font(bodyFont)
        }
    }
    
    private func groupByCategory(_ iaps: [IAP]) -> [(String, [IAP])] {
        let grouped = Dictionary(grouping: iaps, by: { $0.category })
        return grouped.sorted(by: { $0.key < $1.key })
    }
    
    private func isPurchased(iap: IAP) -> Bool {
        if let features = UserDefaults.standard.object(forKey: "iaps") as? [String: Any] {
            switch iap.type {
            case .publishRecordings:
                return features["publishRecordings"] as? Bool ?? false
            case .twoTracks:
                if let trackCount = features["trackCount"] as? Int16 { return trackCount > 1 }
                return false
            case .threeTracks:
                if let trackCount = features["trackCount"] as? Int16 { return trackCount > 2 }
                return false
            case .fourTracks:
                if let trackCount = features["trackCount"] as? Int16 { return trackCount > 3 }
                return false
            }
        }
        return false
    }
    
    private func updateFeatures(type: IAPType) {
        guard let config = dataManager.configuration else {
            saveConfiguration(existing: nil, type: type)
            return
        }
        saveConfiguration(existing: config, type: type)
    }
    
    private func saveConfiguration(existing: Configuration?, type: IAPType) {
        var publishRecordings = false
        var trackCount: Int16 = 1
        
        switch type {
        case .publishRecordings:
            publishRecordings = true
            trackCount = existing?.trackCount ?? 1
        case .twoTracks:
            publishRecordings = existing?.publishRecordings ?? false
            trackCount = 2
        case .threeTracks:
            publishRecordings = existing?.publishRecordings ?? false
            trackCount = 3
        case .fourTracks:
            publishRecordings = existing?.publishRecordings ?? false
            trackCount = 4
        }
        
        dataManager.saveConfiguration(existing: existing, publishRecordings: publishRecordings, trackCount: trackCount)
        UserDefaults.standard.set(["publishRecordings": publishRecordings, "trackCount": trackCount], forKey: "iaps")
    }
}

struct RecordingsStoreView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsStoreView(
            viewModel: IAPViewModel(service: IAPService.shared, endpoint: .fetchInAppPurchases)
        )
    }
}
