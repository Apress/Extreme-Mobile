//
//  PublishedRecordingsViewModel.swift
//  RecordingsFW
//
//  Created by Charlie Cocchiaro on 2025-10-31.
//  Copyright © 2025 Charlie Cocchiaro. All rights reserved.
//
//  This source code and all associated materials are the confidential property of Charlie Cocchiaro.
//  Unauthorized copying, distribution, or disclosure of this file, via any medium, is strictly prohibited.
//

import Foundation
import Combine

class PublishedRecordingsViewModel: RefreshableViewModel, ObservableObject {
    // Dependency Injection...
    private let service: StubAPIService
    private let endpoint: RecordingsEndpoint
    
    private var disposables = Set<AnyCancellable>()
    
    @Published private(set) var recordings: [Recording] = []
    
    init(service: StubAPIService, endpoint: RecordingsEndpoint) {
        self.service = service
        self.endpoint = endpoint
    }
    
    func getRecordings() -> [Recording] {
        return recordings
    }
    
    func refresh() {
        fetch()
    }
    
    func fetch() {
        if let url = URL(string: endpoint.urlString) {
            service.fetch(_t: Recording.self, url: url)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    switch value {
                    case .failure:
                        self?.recordings = []
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] response in
                    self?.recordings = response
                }
                .store(in: &disposables)
        }
    }
}
