//
//  IAP.swift
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation

enum IAPEndpoint {
    case fetchInAppPurchases
    var urlString: String {
        switch self {
        case .fetchInAppPurchases:
            return "https://graphixware.com/iaps"
        }
    }
}

enum IAPError: Error {
    case request(message: String)
    case network(message: String)
    case status(message: String)
    case parsing(message: String)
    case other(message: String)
}

protocol RefreshableViewModel {
    func getIAPs() -> [IAP]
    func refresh()
}

enum IAPType: String, Decodable {
    case publishRecordings = "publishRecordings"
    case twoTracks = "twoTracks"
    case threeTracks = "threeTracks"
    case fourTracks = "fourTracks"
}

struct IAP: Hashable, Identifiable, Decodable {
    var id: String { name }
    let category: String
    let name: String
    let price: Double
    let type: IAPType
    
    init(category: String, name: String, price: Double, type: IAPType) {
        self.category = category
        self.name = name
        self.price = price
        self.type = type
    }
}
