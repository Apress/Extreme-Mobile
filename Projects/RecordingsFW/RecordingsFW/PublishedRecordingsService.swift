//
//  PublishedRecordingsService.swift
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

protocol StubAPIService {
    func fetch<T>(_t: T.Type, url: URL) -> AnyPublisher<[T],RecordingsError> where T: Decodable
}

class PublishedRecordingsService: StubAPIService {
    public static let shared = PublishedRecordingsService()
    
    private init() {
    }
    
    func fetch<T>(_t: T.Type, url: URL) -> AnyPublisher<[T], RecordingsError> where T : Decodable {
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                RecordingsError.network(message: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
    
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, RecordingsError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                RecordingsError.parsing(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
