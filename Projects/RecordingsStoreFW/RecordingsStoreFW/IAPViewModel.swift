//
//  IAPViewModel.swift
//  RecordingsStoreFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation
import Combine

class IAPViewModel: ObservableObject, RefreshableViewModel {
    // Dependency Injection...
    private let service: StubAPIService
    private let endpoint: IAPEndpoint
    
    private var disposables = Set<AnyCancellable>()
    
    @Published private(set) var iaps: [IAP] = []
    
    init(service: StubAPIService, endpoint: IAPEndpoint) {
        self.service = service
        self.endpoint = endpoint
    }
    
    func getIAPs() -> [IAP] {
        return iaps
    }
    
    func refresh() {
        fetch()
    }
    
    private func fetch() {
        if let url = URL(string: endpoint.urlString) {
            service.fetch(_t: IAP.self, url: url)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    switch value {
                    case .failure:
                        self?.iaps = []
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] response in
                    self?.iaps = response
                }
                .store(in: &disposables)
        }
    }
}
